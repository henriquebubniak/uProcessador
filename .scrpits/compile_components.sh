#!/usr/bin/bash

cd /home/henrique/Documents/Faculdade/2023_2/arq_comp/uProcessador/components/u_processor

files=`find . -type f -name "*.vhdl" ! -name "u_processor*"`

for file in $files
do
    ghdl -a  ${file##*'/'}
done

out_dir=`find . -type d -name "out"`

#if [ -z $out_dir ] 
#then
#    echo "creating output directory..."
#else
#    echo "cleaning output directory..."
#    rm -r out
#fi

ghdl -a u_processor.vhdl
ghdl -a u_processor_tb.vhdl
ghdl -e u_processor_tb

mkdir out out/cf out/o
mv -t ./out/cf *.cf
mv -t ./out/o *.o


