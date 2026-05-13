# Sub-Offer Visibility Control Update

This update introduces the ability to control the visibility of individual sub-offers from the admin dashboard. This allows administrators to prepare offers in advance or temporarily hide expired offers without deleting them.

## 🚀 Key Features

### 1. Visibility Toggle in Forms
When adding a new sub-offer or editing an existing one, a new toggle switch has been added:
- **Location**: Found between the image selection and the save button.
- **Functionality**: 
  - **Visible (ظاهر)**: The sub-offer will be displayed to users in the client application.
  - **Hidden (مخفي)**: The sub-offer will be hidden from users but remain accessible to admins in the dashboard for future updates.
- **Visual Feedback**: The toggle container changes color (Green for visible, Red for hidden) and provides clear text feedback (**ظاهر للمستخدمين** / **مخفي عن المستخدمين**).

### 2. Dashboard Status Indicator
The sub-offer cards on the admin dashboard now include a status badge for quick identification:
- **Green Badge (ظاهر)**: Indicates the offer is currently live.
- **Red Badge (مخفي)**: Indicates the offer is currently hidden.

---

## 🛠 Technical Implementation Details

### Data Model
The `SubOffer` model in `offer_model.dart` now includes an `isVisible` boolean attribute.
```dart
class SubOffer {
  // ...
  final bool isVisible;

  SubOffer({
    // ...
    this.isVisible = true, // Defaults to true for existing data
  });
}
```

### Backend (Firestore)
- The `isVisible` field is automatically synchronized with Firestore during both "Add" and "Update" operations.
- **Data Compatibility**: Existing sub-offers that do not have this field in Firestore will be treated as `isVisible: true` by default in the application logic.

### UI Components
- **`NewSubOfferView`**: Implements the `Obx` wrapped toggle switch for real-time reactive feedback.
- **`SubOfferWidget`**: Uses a `Positioned` badge overlaid on the offer image to show the current visibility status.

---

## 📝 Usage Note
To hide an offer, simply navigate to the sub-offer edit screen, switch off the "Visibility" toggle, and click **Save (حفظ)**. The change will reflect immediately on the dashboard and for the clients.
