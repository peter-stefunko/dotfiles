#!/bin/bash

index=$(qdbus org.kde.keyboard /Layouts getLayout)
layout_index=$((2+$index*6))
layout=$(qdbus --literal org.kde.keyboard /Layouts getLayoutsList | awk -F '"' -v idx="$layout_index" '{print $idx}')

echo $layout
