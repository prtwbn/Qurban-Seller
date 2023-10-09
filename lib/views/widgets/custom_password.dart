import 'package:qurban_seller/const/const.dart';

class CustomPassword extends StatefulWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final bool isPass;

  CustomPassword(
      {this.title, this.hint, this.controller, required this.isPass});

  @override
  _CustomPasswordState createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) // Add null check here
          widget.title!.text.color(black).size(16).make(),
        5.heightBox,
        TextFormField(
          obscureText: widget.isPass ? _isObscure : false,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: widget.isPass
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: textfieldGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
            hintStyle: const TextStyle(
              color: textfieldGrey,
            ),
            hintText: widget.hint,
            isDense: true,
            fillColor: lightGrey,
            filled: true,
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )), // OutlineInputBorder
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )),
            ),
          ),
      
        
        5.heightBox,
      ],
    );
  }
}
