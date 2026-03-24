# Instructions: Update Client App for Weight Synchronization

To support live weight synchronization when clients submit weekly progress in your separate Client App, you need to apply updates across **3 layers**: Firestore Database, the Client Model class, and the Submission controller.

---

## 🟢 1. Firestore Database Level
Add these numerical keys directly to your parent **`clients`** collection documents (not inside subcollections).

| Field Name | Type | Description |
| :--- | :--- | :--- |
| **`last_weight`** | `number` / `double` | Stores the latest recorded weight value. |
| **`last_weight_date`** | `timestamp` / `string` | Stores the exact date that weight was added. |

---

## 🔵 2. Model Class Level (`ClientProfileModel`)
Update your Dart model representing the parent client document structure:

### **A. Add fields**
```dart
class ClientProfileModel {
  final double? lastWeight;
  final DateTime? lastWeightDate;

  ClientProfileModel({
    this.lastWeight,
    this.lastWeightDate,
    // ...
  });
}
```

### **B. Map from JSON (`fromJson`)**
```dart
factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
  return ClientProfileModel(
    lastWeight: json['last_weight'] != null ? (json['last_weight'] as num).toDouble() : null,
    lastWeightDate: json['last_weight_date'] != null ? DateTime.parse(json['last_weight_date']) : null,
    // ...
  );
}
```

### **C. Map to JSON (`toJson`)**
```dart
Map<String, dynamic> toJson() {
  return {
    'last_weight': lastWeight,
    'last_weight_date': lastWeightDate?.toIso8601String(),
    // ...
  };
}
```

### **D. Add on CopyWith method**
```dart
ClientProfileModel copyWith({
  double? lastWeight,
  DateTime? lastWeightDate,
}) {
  return ClientProfileModel(
    lastWeight: lastWeight ?? this.lastWeight,
    lastWeightDate: lastWeightDate ?? this.lastWeightDate,
  );
}
```

---

## 🟡 3. Controller Level (Update on Submit)
Find the Submission function pushed via creation triggers inside your controller workflows (e.g., `AddWeekProgressController.submit`):

Right inside the **Success Block** callback (after successfully adding new weekly progress payloads to Firestore), insert the overwriting synchronization step below:

```dart
// 1. Submit the week progress normally
await addWeekProgressUseCase(progress);

// 2. 🔥 Insert synchronization trigger
if (progress.weight > 0) {
  try {
    final clientRepo = FirebaseClientRepository(FirebaseFirestore.instance);
    final client = await clientRepo.getClientById(clientId);
    
    if (client != null) {
      final updatedClient = client.copyWith(
        lastWeight: progress.weight,
        lastWeightDate: progress.date,
      );
      
      // Update parent document fields in Firestore
      await clientRepo.updateClient(updatedClient);
      
      // Update local memory controllers if screen is strictly Reactively framed
      if (Get.isRegistered<ClientProfileController>()) {
         Get.find<ClientProfileController>().client.value = updatedClient;
      }
    }
  } catch (e) {
    log('Failed to update client weight: $e');
  }
}
```
