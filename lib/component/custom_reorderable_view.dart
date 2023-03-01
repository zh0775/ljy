import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class CustomReorderableView extends StatefulWidget {
  final Function(int newIndex, int oldIndex) changeIndex;
  final List listData;
  const CustomReorderableView(
      {Key? key, required this.changeIndex, required this.listData})
      : super(key: key);

  @override
  State<CustomReorderableView> createState() => _CustomReorderableViewState();
}

class _CustomReorderableViewState extends State<CustomReorderableView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 375.w,
        height: widget.listData != null && widget.listData.isNotEmpty
            ? widget.listData.length * 60.5.w
            : 0,
        child: ReorderableListView.builder(
          itemBuilder: (context, index) {
            return addedCell(index, widget.listData[index]);
          },
          itemCount: widget.listData != null && widget.listData.isNotEmpty
              ? widget.listData.length
              : 0,
          onReorder: (oldIndex, newIndex) {
            dynamic item = widget.listData.removeAt(oldIndex);
            widget.listData.insert(newIndex, item);
            // controller.update([controller.addedModuleListBuildId]);
          },
        ));
  }

  Widget addedCell(int index, Map data) {
    bool isFirst = (index == 0);
    bool isLast = (index == widget.listData.length - 1);
    return ReorderableItem(
      key: ValueKey<String>("addedCell_${data["id"]}"),
      childBuilder: (context, state) {
        BoxDecoration decoration;

        if (state == ReorderableItemState.dragProxy ||
            state == ReorderableItemState.dragProxyFinished) {
          // slightly transparent background white dragging (just like on iOS)
          decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
        } else {
          bool placeholder = state == ReorderableItemState.placeholder;
          decoration = BoxDecoration(
              border: Border(
                  top: isFirst && !placeholder
                      ? Divider.createBorderSide(context) //
                      : BorderSide.none,
                  bottom: isLast && placeholder
                      ? BorderSide.none //
                      : Divider.createBorderSide(context)),
              color: placeholder ? null : Colors.white);
        }

        // For iOS dragging mode, there will be drag handle on the right that triggers
        // reordering; For android mode it will be just an empty container
        Widget dragHandle = ReorderableListener(
          child: Container(
            padding: const EdgeInsets.only(right: 18.0, left: 18.0),
            color: const Color(0x08000000),
            child: const Center(
              child: Icon(Icons.reorder, color: Color(0xFF888888)),
            ),
          ),
        );

        Widget content = Container(
          decoration: decoration,
          child: SafeArea(
              top: false,
              bottom: false,
              child: Opacity(
                // hide content for placeholder
                opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 14.0),
                        child: Text(data["name"],
                            style: Theme.of(context).textTheme.subtitle1),
                      )),
                      // Triggers the reordering
                      dragHandle,
                    ],
                  ),
                ),
              )),
        );

        // For android dragging mode, wrap the entire content in DelayedReorderableListener
        // if (draggingMode == DraggingMode.android) {
        //   content = DelayedReorderableListener(
        //     child: content,
        //   );
        // }

        return content;
      },
    );
  }
}
