import 'package:flutter/material.dart';
import 'package:musify/core/ui.dart';

class FutureFactory<T> {
    FutureBuilder<T> networkFuture(Future<T> networkCall, Widget onSuccess(T data)) {
        return FutureBuilder(
            future: networkCall,
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                    return onSuccess(snapshot.data);
                } else if (snapshot.hasError) {
                    UI.createErrorDialog(context, "Error interno del servidor.");
                    return Column();
                }
                return Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                        child: CircularProgressIndicator(), 
                        widthFactor: 50,
                    ),
                );
            },
        );
    }
}
