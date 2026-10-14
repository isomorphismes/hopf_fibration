# Division glyph and its actual compiler

The maintained Idriç producer emits literal binary `÷` into `hopf_math.c`.
The checked-in generated source and the seven binary divisions in the Android
shell use the same operator. ICK normalizes this token at the C frontend after
preprocessing, with the existing `/` semantics and precedence. Compound `/=`
is unchanged: ICK does not implement `÷=`. Shader text, comments, historical
Sage/Cython and Walczyk reference sources retain their original language.

The producer is Idriç `94dfd99bd3e376507fedc8611053b7173b2519f0`.
The C frontend is ICK `c61e448251744a2f40ad743ebef1a027bdcd2f9d`, with GCC
reference `6294f1d9e7536e5ffcde09d1528c918d63abfef5`. The shared ai-ci
Android producer is pinned in both workflows and F-Droid metadata.

`hopf_android.c` and `hopf_math.c` both pass through ICK to assembly. The
declared NDK `29.0.14206865` assembles that output and links it with Bionic,
EGL, GLES and the unmodified NDK-owned `native_app_glue`. CMake cannot quietly
send a failed owned translation unit to NDK Clang. Each ABI receives its own
installed ICK compiler; the APK retains all three original ABIs.

The common compiler interface preserves the NDK's complete compile flags,
including `_FORTIFY_SOURCE=2`, stack protection, debug information and warning
settings. Its explicit API26 Fortify adapter maps supported Bionic wrappers
to checked builtins; unsupported surfaces fail closed. The existing hardening
level is never removed to admit the glyph. Debug's Clang spelling for complete
type information is translated to the corresponding GNU compiler option by
the shared interface.

The host math CI first checks the Idriç-produced files byte for byte, then
builds and executes the original mathematical test suite using ICK. It also
executes ai-ci's `build-toolchain-v0` contract and prints the stage manifest.
Both debug and unsigned-release Android workflows bootstrap and qualify all
three C frontends, restore executable compiler stages from tar archives, build
through the same CMake interface, and check that all three shared libraries
are packaged. Qualification receipts travel with the compiler artifacts.

## Observed local evidence

- Fresh exact Idriç compilation, generated-file reproducibility, and unchanged
  `hopf_math.h`: PASS.
- Original ASCII and migrated generated C both execute the existing host
  mathematical tests with ICK: `hopf_math_test: ok`.
- Actual NDK r29/API26 ARM Debug and Release, plus AArch64 Release CMake: both owned C translation units compile
  through ICK, NDK assembles and fully links `libhopf.so`, preserving Fortify2,
  stack protection, warnings and the configuration's optimization/debug flags: PASS.
- Actual NDK r29/API26 x86_64 generated math compiles, assembles and links with
  Fortify2 and `--no-undefined`: PASS.

These are source, execution and library-link results. Hosted APK builds,
F-Droid's own source rebuild, installation, launch and physical-device behavior
are separate acceptance stages; the local library evidence does not claim them.
