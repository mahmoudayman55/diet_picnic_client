
import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:diet_picnic_client/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final int maxLines;


  const ReviewWidget({
    super.key,
    required this.review,
    required this.maxLines,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المستخدم
              ClipRRect(borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child:  CustomCachedNetworkImage(imageUrl: review.profileImage),
                ),
              ),
              const SizedBox(width: 12),
          
              // نصوص المراجعة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم والتاريخ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.name,
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateTimeFormatter.dateTimeToFullDate(review.date),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
          
                    const SizedBox(height: 6),
          
                    // النجوم
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < review.rate ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16.sp,
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 8),
          
                    // نص الريفيو
                    Flexible(
                      child: Text(
                        review.comment,overflow: TextOverflow.ellipsis,maxLines: maxLines,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
