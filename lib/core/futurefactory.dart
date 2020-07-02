import 'package:flutter/material.dart';

class FutureFactory<T> {
    FutureBuilder<T> networkFuture(Future<T> networkCall, Widget onSuccess(T data), onFailure()) {
        return FutureBuilder(
            future: networkCall,
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                    return onSuccess(snapshot.data);
                } else if (snapshot.hasError) {
                    return onFailure();
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
