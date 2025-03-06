import 'package:customer_app/_SERVICE/product_model.dart';
import 'package:customer_app/_SERVICE/shoporama.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shortid/shortid.dart';

import '../FORM/form.dart';
import '../STD_WIDGET/package.dart';

class ProductEditScreen extends StatelessWidget {
  final int supplierId;
  ProductEditScreen({super.key, required this.supplierId});

  var groupSchema = FormSchema(
    fields: {
      'id': Field(type: FieldType.string, value: shortid.generate(), validate: ["hidden"]),
      'name': Field(type: FieldType.string, title: tr('#product.edit.name'), helptext: tr('#product.edit.name_help'), value: null, validate: ["mandatory", "minLength:4"]),
      'price': Field(type: FieldType.number, title: tr('#product.edit.price'), helptext: tr('#product.edit.price_help'), value: null, validate: ["mandatory"]),
      'count': Field(type: FieldType.number, title: tr('#product.edit.count'), helptext: tr('#product.edit.count_help'), value: null, validate: ["mandatory"]),
      'descriptionA': Field(type: FieldType.string, title: tr('#product.edit.description'), helptext: tr('#product.edit.description_help'), value: null, validate: ["minLength:4"]),
      'isOnline': Field(type: FieldType.toggle, title: tr('#product.edit.isOnline'), helptext: tr('#product.edit.isOnline_help'), value: null, validate: []),
      'submit': Field(type: FieldType.button, title: tr('#submit'), value: null, validate: []),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/shoporama.png'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(FetchSupplierProvider(supplierId: supplierId));

              return state.when(
                data: (supplierId) {
                  return Column(
                    children: [
                      DynamicForm(
                        formSchema: groupSchema,
                        defaultValues: {'supplierId': supplierId!.supplierId, 'supplier_name': supplierId.name},
                        onChanged: (p0) {},
                        onLookup: (fieldKey) async => {},
                        onFieldChanged: (key, value) => {},
                        onButtonTap: (values, defaultValues) async {
                          try {
                            await onSubmit(values, defaultValues);
                          } catch (e) {
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('#error.try_agian'))));
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => NothingFound(),
                loading: () => const Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10), child: Center(child: SpinKitCircle(color: Colors.amber, size: 50.0))),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(Map<String, dynamic> values, Map<String, dynamic> defaultValues) async {
    defaultValues.addAll(values);
    final product = Product.fromFormSimple(defaultValues);
    await ShoporamaService().postProductSimple(product: product);
    return;
  }
}
