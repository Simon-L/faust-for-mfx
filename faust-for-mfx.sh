# Dependencies

# wget https://apt.llvm.org/llvm.sh
# chmod +x llvm.sh
# sudo ./llvm.sh 16
# apt install -y zstd libncurses-dev libxml2-dev cmake build-essential libpolly-16-dev

wget https://github.com/grame-cncm/faust/archive/refs/heads/master-dev.zip
unzip master-dev.zip
mv faust-master-dev/* .
rm -r faust-master-dev master-dev.zip

cat <<EOF > build/backends/mfx.cmake
set ( C_BACKEND      COMPILER STATIC DYNAMIC      CACHE STRING  "Include C backend" FORCE )
set ( CODEBOX_BACKEND      COMPILER STATIC DYNAMIC      CACHE STRING  "Include Codebox backend" FORCE )
set ( CPP_BACKEND    COMPILER STATIC DYNAMIC      CACHE STRING  "Include CPP backend" FORCE )
set ( CMAJOR_BACKEND                     OFF  CACHE STRING  "Include Cmajor backend" FORCE )
#set ( CMAJOR_BACKEND                     OFF       CACHE STRING  "Include Cmajor backend" FORCE )
set ( CSHARP_BACKEND                     OFF       CACHE STRING  "Include CSharp backend" FORCE )
set ( DLANG_BACKEND                      OFF       CACHE STRING  "Include Dlang backend" FORCE )
set ( FIR_BACKEND                        OFF      CACHE STRING  "Include FIR backend" FORCE )
set ( INTERP_BACKEND                     OFF      CACHE STRING  "Include Interpreter backend" FORCE )
set ( JAVA_BACKEND                       OFF       CACHE STRING  "Include JAVA backend" FORCE )
set ( JAX_BACKEND                        OFF       CACHE STRING  "Include JAX backend"  FORCE )
set ( JULIA_BACKEND                      OFF       CACHE STRING  "Include Julia backend" FORCE )
set ( JSFX_BACKEND                      OFF       CACHE STRING  "Include JSFX backend" FORCE )
set ( LLVM_BACKEND   COMPILER STATIC DYNAMIC      CACHE STRING  "Include LLVM backend" FORCE )
set ( OLDCPP_BACKEND COMPILER STATIC DYNAMIC      CACHE STRING  "Include old CPP backend" FORCE )
set ( RUST_BACKEND                       OFF      CACHE STRING  "Include Rust backend" FORCE )
set ( TEMPLATE_BACKEND                   OFF      CACHE STRING  "Include Template backend" FORCE )
set ( VHDL_BACKEND                       OFF      CACHE STRING  "Include VHLD backend" FORCE )
set ( WASM_BACKEND                       OFF      CACHE STRING  "Include WASM backend" FORCE )
EOF

find /usr -name llvm-config
export PATH="/usr/lib/llvm-16/bin:$PATH"
export LLVM_ROOT=$(llvm-config --prefix | tr '\n' ' ')
echo "LLVM_ROOT: " $LLVM_ROOT
cd build
cmake -C ./backends/mfx.cmake -C ./targets/all.cmake . -Bbuild -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=faust -DUSE_LLVM_CONFIG=ON
cmake --build build --config Debug --parallel 16 --verbose
cmake --build build --config Debug --target install --verbose
cd faust/share/faust
wget https://github.com/grame-cncm/faustlibraries/archive/refs/heads/master.zip
unzip master.zip
mv faustlibraries-master/* .
rm -r faustlibraries-master master.zip
cd ../../..
tar cJf faust.tar.xz -C faust .