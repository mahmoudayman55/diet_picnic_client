# Exams Feature Implementation Details & Structure

This document outlines the architecture and remaining work for the Exams feature in the `diet_picnic` application.

## 🏗 Architecture Overview

The feature follows **Clean Architecture** and uses **GetX** for state management. It is integrated with **Firebase Cloud Firestore** for data persistence.

### 1. Domain Layer (`lib/modules/clients/domain`)

*   **Entities**:
    *   `ExamEntity`: Main exam object (title, visibility, questions, prizes).
    *   `QuestionEntity`: Single question (title, list of options, correct index).
    *   `PrizeEntity`: Reward based on score range, with per-prize availability.
    *   `ExamSubmissionEntity`: Record of a user's attempt (score, answers, prize won).
*   **Use Cases**:
    *   `GetExamsUseCase`: Fetches all exams.
    *   `SubmitExamUseCase`: Saves user answers and results.
    *   `GetExamResultsUseCase`: Retrieves submissions for a specific exam.
    *   `AddExamUseCase` / `UpdateExamUseCase` / `DeleteExamUseCase`: Admin CRUD operations.

### 2. Data Layer (`lib/modules/clients/data`)

*   **Models**: `ExamModel`, `QuestionModel`, `PrizeModel`, `ExamSubmissionModel` (JSON serialization for Firestore).
*   **Repositories**: `FirebaseExamRepository` implementing the `ExamRepository` interface.
*   **Utilities**: `ImgbbUploader` for handling prize image uploads to ImgBB.

### 3. Presentation Layer (`lib/modules/clients/presentation`)

*   **Controllers**:
    *   `ExamsController`: Managing the list of exams and admin toggles.
    *   `AddExamController`: Complex form state for creating/editing exams with dynamic questions/prizes.
    *   `ExamTestController`: Take-exam logic, scoring, and evaluation.
    *   `ExamResultsController`: Viewing statistics.
*   **Views**:
    *   `ExamsView`: Dashboard for exams.
    *   `AddExamView`: Admin form.
    *   `ExamTestView`: Question-by-question test interface.
    *   `ExamResultsView`: Result listing.

## 🧱 Dual-Level Availability Support

The system supports granular availability:
1.  **Exam Level**: `ExamAvailability` (All, Subscribers, Non-Subscribers) determines if the exam is visible to a user.
2.  **Prize Level**: Individual prizes can have their own availability and target specific **Package IDs**.

---

## 🛡 Detailed Validation & Filtration Settings

To ensure the system is robust, the following settings must be strictly enforced:

### 1. Admin Validation (`AddExamController`)
*   **Availability Compatibility**: A prize's availability cannot exceed the exam's availability (e.g., if the exam is for `nonSubscribers`, prizes cannot be for `subscribers`).
*   **Package Enforcement**: If a prize is for `subscribers` or `all`, at least one package must be selected.
*   **Score Range Sanity**: `maxScore` must be at least equal to `minScore`. Overlapping score ranges should ideally be flagged or prevented.
*   **Image Presence**: An exam should have a `prizeImage` to ensure visual consistency.

### 2. Client Filtration & Access (`ExamsController`)
*   **Visibility & Activity**: Only `isVisible == true` and `isActive == true` exams are shown.
*   **Entrance Guarding**:
    *   Clients with no package (`package == null`) only see exams where `availability` is `all` or `nonSubscribers`.
    *   Clients with a package only see exams where `availability` is `all` or `subscribers`.

### 3. Prize Evaluation logic (`ExamTestController`)
*   **Status-Aware Evaluation**: When calculating the winner, the system MUST check if the user qualifies for the prize's specific availability layer.
    *   Example: A "Bonus Pack" prize limited to "Gold Package" subscribers must verify the user's `package.id` before awarding.
*   **Real Identity**: Replace `admin_test` hardcoded string with the actual `auth.currentUser.uid`.

## 🚀 Remaining Steps for Client-Side Completion

### 1. User Session Integration
> [!IMPORTANT]
> The current `ExamTestController` uses a hardcoded `admin_test` ID. This must be updated to use the logged-in user's UID and name from `ClientProfileController`.

### 2. Status-Aware Evaluation
*   Modify `submitTest` to cross-reference the `wonPrize.availability` and `wonPrize.packageIds` with the user's current subscription.

### 3. Prize Redemption Logic
*   When a user wins a prize, automatically update the `assigned_packages` or equivalent in their profile if the prize grants access.

## ✅ Verification Plan

### Manual Verification
1.  **Mismatch Test**: Attempt to save a "Subscriber" prize on an exam for "Non-Subscribers" (should fail).
2.  **Access Test**: Log in as a non-subscriber and verify that "Subscriber-only" exams are hidden.
3.  **Reward Test**: Take an exam and verify that a prize is only awarded if the user's current package matches the prize's package requirements.
