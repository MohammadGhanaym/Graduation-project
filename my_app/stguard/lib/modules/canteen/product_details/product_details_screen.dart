import 'package:flutter/material.dart';
import 'package:stguard/models/canteen_product_model.dart';
import 'package:stguard/shared/styles/themes.dart';

class ProductDetailsScreen extends StatelessWidget {
  final CanteenProductModel product;

  ProductDetailsScreen({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Product Details', style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors
        .white),),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
                      width: 201,
                      height: 201,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: defaultColor)),
                      child: Container(
                        width: 200,
                        height: 200,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image(
                          image: NetworkImage(
                            product.image,
                          ),
                          errorBuilder: (context, error, stackTrace) =>
                              const Image(
                                  image:
                                      AssetImage('assets/images/no-image.png')),
                        ),
                      ),
                    ),
                     const SizedBox(height: 20),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                   Text(
                    'Price',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20,),
                  Text(product.price.toStringAsFixed(2), style: Theme.of(context).textTheme.titleLarge,)
                ],
              ),
              const SizedBox(height: 10),
                         Row(
                children: [
                   Text(
                    'Calories (kcal)',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20,),
                  Text(product.calories.toString(), style: Theme.of(context).textTheme.titleLarge,)
                ],
              ),
      
              const SizedBox(height: 10),
              
                 Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)
                ),const SizedBox(height: 10),
                if (product.ingredients != null)
              Wrap(
                spacing: 8,
                runSpacing: 5,
                children: product.ingredients!
                    .map(
                      (ingredient) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: defaultColor.withOpacity(0.3)),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$ingredient',
                            style: Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
               Text(
                'Potential Allergies',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)
              ),const SizedBox(height: 10),
              if (product.allergies != null)
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: 
                  product.allergies!
                      .map(
                        (allergy) => Container(
                             decoration: BoxDecoration(
                          border: Border.all(color: defaultColor.withOpacity(0.3)),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$allergy',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
