# Exam Prize Distribution – Technical Reference

> **Purpose:** This document explains exactly how the admin configures exam prizes and how the correct prize is selected for a client after they submit an exam. It is intended as a reference for any agent implementing the client-app exam submission flow.

---

## 1. Data Model Overview

### `ExamEntity`
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Firestore document ID |
| `title` | `String` | Display title of the exam |
| `isVisible` | `bool` | Whether the exam is visible to clients |
| `isActive` | `bool` | Whether clients can submit answers |
| `availability` | `ExamAvailability` | Who the **exam itself** is available to |
| `prizeImage` | `String` | URL of the coupon/prize background image |
| `questions` | `List<QuestionEntity>` | Ordered list of MCQ questions |
| `prizes` | `List<PrizeEntity>` | Ordered list of prize tiers |
| `createdAt` | `DateTime` | Creation timestamp |

### `PrizeEntity`
| Field | Type | Description |
|---|---|---|
| `prizeName` | `String` | The prize label shown on the coupon (e.g. "خصم 20%") |
| `minScore` | `int` | Minimum correct answers (inclusive) to qualify |
| `maxScore` | `int` | Maximum correct answers (inclusive) to qualify |
| `availability` | `ExamAvailability` | Who this **specific prize** targets |
| `packageIds` | `List<String>` | Firestore IDs of packages included in this prize |
| `packageNames` | `List<String>` | Display names of those packages (denormalised) |

### `ExamAvailability` Enum
| Value | Firestore String | Arabic Label | Meaning |
|---|---|---|---|
| `all` | `"all"` | الكل | Prize is for everyone |
| `subscribers` | `"subscribers"` | المشتركين فقط | Prize is only for active subscribers |
| `nonSubscribers` | `"nonSubscribers"` | غير المشتركين | Prize is only for non-subscribers |

---

## 2. Prize Matching Algorithm

The core logic lives in **`ExamTestController.submitTest()`** (and must be replicated in the client app controller). After calculating the score:

```dart
PrizeEntity? wonPrize;
for (final prize in exam.prizes) {
  if (calculatedScore >= prize.minScore &&
      calculatedScore <= prize.maxScore) {
    wonPrize = prize;
    break;   // ← First matching prize wins; ORDER MATTERS
  }
}
```

### Step-by-Step Decision Flow

```
User submits exam
       │
       ▼
Calculate score = number of correct answers (integer)
       │
       ▼
Iterate exam.prizes IN ORDER (prize[0], prize[1], ...)
       │
       ├─ Does score fall within [prize.minScore, prize.maxScore]?
       │         YES → candidate prize found, STOP iterating
       │         NO  → continue to next prize
       │
       ▼
Candidate prize found?
   NO  → prizeWon = null  ("لم تحصل على جائزة هذه المرة")
   YES → Apply availability filter:
         │
         ├─ prize.availability == ExamAvailability.all
         │       → Prize awarded regardless of subscription status
         │
         ├─ prize.availability == ExamAvailability.subscribers
         │       → Prize awarded ONLY if the client has an active
         │         subscription AND the client's packageId is in
         │         prize.packageIds
         │
         └─ prize.availability == ExamAvailability.nonSubscribers
                 → Prize awarded ONLY if the client has NO active
                   subscription. prize.packageIds is ignored / empty.
```

> [!IMPORTANT]
> The current **admin test mode** (`ExamTestController`) does **not** apply the availability/package filter — it awards the first score-matching prize unconditionally. The **client app** must implement the full filter using the client's actual subscription state.

---

## 3. Admin Creation Flow (AddExamController / AddExamView)

When an admin creates or edits an exam, each prize row (`_PrizeRow`) has three axes of configuration:

### 3.1 Prize Name
Free-text field — becomes `prizeName` on the coupon.

### 3.2 Score Range
Two number fields:
- **أدنى درجة** → `minScore` (inclusive lower bound)
- **أعلى درجة** → `maxScore` (inclusive upper bound)

Ranges **can overlap** across prizes, but only the **first matching prize** (by list order) is awarded.

### 3.3 Availability + Package Selection

| Prize Availability | Package Chips Shown? | Validation Rule |
|---|---|---|
| `all` | ✅ Yes | At least one package must be selected |
| `subscribers` | ✅ Yes | At least one package must be selected |
| `nonSubscribers` | ❌ Hidden | No package required |

When `availability` is `all` or `subscribers`, the admin selects which **packages** are included via `FilterChip` widgets. A "الكل" chip selects all loaded packages at once. These are stored as parallel lists: `packageIds` and `packageNames`.

**Save-time validation** (`AddExamController.saveOrUpdate`):
```dart
if ((availability == all || availability == subscribers) &&
    selectedPackageIds.isEmpty) {
  // Show error: "يرجى اختيار باقة واحدة على الأقل للجائزة رقم X"
  return;
}
```

---

## 4. Firestore Storage Schema

### Collection: `exams`
```json
{
  "title": "امتحان التغذية",
  "isVisible": true,
  "isActive": true,
  "availability": "all",
  "prizeImage": "https://...",
  "createdAt": 1715000000000,
  "questions": [
    {
      "title": "ما هو البروتين؟",
      "options": ["خيار أ", "خيار ب", "خيار ج", "خيار د"],
      "correctAnswerIndex": 2
    }
  ],
  "prizes": [
    {
      "prizeName": "خصم 30%",
      "minScore": 8,
      "maxScore": 10,
      "availability": "subscribers",
      "packageIds": ["pkg_abc", "pkg_xyz"],
      "packageNames": ["باقة ذهبية", "باقة فضية"]
    },
    {
      "prizeName": "خصم 10%",
      "minScore": 5,
      "maxScore": 7,
      "availability": "nonSubscribers",
      "packageIds": [],
      "packageNames": []
    }
  ]
}
```

### Collection: `exam_submissions`
```json
{
  "examId": "EXAM_DOC_ID",
  "examTitle": "امتحان التغذية",
  "clientId": "CLIENT_UID",
  "clientName": "Ahmed Ali",
  "score": 9,
  "totalQuestions": 10,
  "packageId": "pkg_abc",
  "packageName": "باقة ذهبية",
  "prizeWon": "خصم 30%",
  "submittedAt": Timestamp,
  "isAdminTest": false,
  "answers": [0, 1, 2, null, 3, ...]
}
```

---

## 5. Client App: What the Agent Must Implement

When a **real client** submits an exam, the controller must:

### 5.1 Know the Client's Subscription State
Before resolving the prize, fetch (or have available) from the client profile:
- `clientPackageId` — the Firestore ID of the package the client is currently subscribed to, **or** `null`/empty if not subscribed.
- `isSubscriber` = `clientPackageId != null && clientPackageId.isNotEmpty`

### 5.2 Full Prize Resolution Logic

```dart
PrizeEntity? wonPrize;

for (final prize in exam.prizes) {
  // Step 1: Score range check
  if (calculatedScore < prize.minScore || calculatedScore > prize.maxScore) {
    continue;
  }

  // Step 2: Availability check
  final av = prize.availability;

  if (av == ExamAvailability.nonSubscribers) {
    // Client must NOT be subscribed
    if (!isSubscriber) {
      wonPrize = prize;
      break;
    }
  } else if (av == ExamAvailability.subscribers) {
    // Client must be subscribed AND their package must be in the prize's list
    if (isSubscriber && prize.packageIds.contains(clientPackageId)) {
      wonPrize = prize;
      break;
    }
  } else {
    // ExamAvailability.all — any client qualifies if score matches,
    // but check package membership if prize has packages defined
    if (prize.packageIds.isEmpty ||
        (isSubscriber && prize.packageIds.contains(clientPackageId)) ||
        !isSubscriber) {
      wonPrize = prize;
      break;
    }
  }
}
```

### 5.3 Submission to Firestore

After resolving `wonPrize`, build and submit an `ExamSubmissionModel`:

```dart
ExamSubmissionModel(
  id: '',                              // Firestore auto-generates
  examId: exam.id,
  examTitle: exam.title,
  clientId: currentUser.uid,
  clientName: currentUser.name,
  score: calculatedScore,
  totalQuestions: exam.questions.length,
  packageId: wonPrize?.packageIds.join(', '),   // can be null
  packageName: wonPrize?.packageNames.join(', '), // can be null
  prizeWon: wonPrize?.prizeName,                 // null = no prize
  submittedAt: DateTime.now(),
  isAdminTest: false,
  answers: answers.map((a) => a.value).toList(),
)
```

> [!NOTE]
> A client who has already submitted cannot re-submit (check `exam_submissions` for `examId == exam.id && clientId == currentUser.uid && isAdminTest == false` before showing the exam).

---

## 6. Worked Examples

### Example Exam: 10 Questions, 3 Prize Tiers
| Prize | Score Range | Availability | Packages |
|---|---|---|---|
| "خصم 50%" | 9–10 | `subscribers` | pkg_gold, pkg_silver |
| "خصم 20%" | 6–8 | `all` | pkg_gold, pkg_silver, pkg_basic |
| "تجربة مجانية" | 0–5 | `nonSubscribers` | _(none)_ |

**Scenario A:** Client scores 9, subscribed to `pkg_gold`
→ Prize #1 matches (score ✅, subscriber ✅, package ✅) → **"خصم 50%"**

**Scenario B:** Client scores 9, **not** subscribed
→ Prize #1 fails (subscriber ❌) → Prize #2 fails (score 9 not in 6–8) → Prize #3 fails (score 9 not in 0–5) → **No prize**

**Scenario C:** Client scores 7, subscribed to `pkg_basic`
→ Prize #1 fails (score 7 not in 9–10) → Prize #2 matches (score ✅, availability=all, package `pkg_basic` in list ✅) → **"خصم 20%"**

**Scenario D:** Client scores 4, **not** subscribed
→ Prize #1 fails → Prize #2: score 4 not in 6–8 → Prize #3 (score ✅, nonSubscriber ✅) → **"تجربة مجانية"**

---

## 7. UI After Prize Resolution

- **Prize won** → Show the `exam.prizeImage` as a coupon card background with the `prizeName` overlaid in a yellow banner. Show the client's name, exam title, and submission date.
- **No prize** → Show a neutral message: "لم تحصل على جائزة هذه المرة".
- The coupon includes fine print: *"استخدام الكوبون مرة واحدة فقط لحامله أو أحد معارفه / مسموح باستخدام كوبون واحد فقط في المرة الواحدة"*.

---

## 8. Key Rules & Edge Cases

| Rule | Detail |
|---|---|
| **First match wins** | Prizes are evaluated in the order they were saved. Put higher-value prizes first. |
| **Score is an integer count** | It equals the number of correctly answered questions, not a percentage. |
| **packageIds can be a comma-joined string** | When multiple packages match, `packageId` in the submission is `"pkg_a, pkg_b"`. Parse accordingly. |
| **`isAdminTest: true` submissions are filtered** | The admin results view (`ExamResultsView`) shows all submissions; a real client should not see admin test submissions. |
| **One submission per client per exam** | Enforce by querying Firestore before allowing the exam to start. |
| **nonSubscribers prize has empty packageIds/Names** | Don't attempt to display package info for these prizes. |
| **`exam.availability` vs `prize.availability`** | `exam.availability` controls who *sees* the exam; `prize.availability` controls who gets the *specific prize* within that exam. Both must be respected. |
