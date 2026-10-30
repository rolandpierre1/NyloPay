import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_cash/util/dimensions.dart';

class HistoryShimmerWidget extends StatelessWidget {
  const HistoryShimmerWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    final  size = MediaQuery.of(context).size;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: 10, padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              color: Colors.black26,
              child: Row(
                children: [
                  SizedBox(
                      height: Dimensions.radiusSizeExtraExtraLarge,
                      width: Dimensions.radiusSizeExtraExtraLarge,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
                        child: Container(color: Colors.black45,),
                      )
                  ),
                  const SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,width: size.width*0.3,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        height: 20,width: size.width*0.4,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        height: 10,width: size.width*0.3,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,width: size.width*0.2,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
