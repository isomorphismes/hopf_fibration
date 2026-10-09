# Third-party and referenced material

`LICENSE` applies only to material that this repository's contributors have authority to license. Third-party dependencies and historical reference material retain their own terms.

## Historical Hopf implementations

The repository contains historical Sage/Cython material and a `walczyk/` reference area used to compare the native Android explorer with earlier Hopf visualizations. Those files are not part of the Android application build and are not relicensed by this repository's GPL grant. Preserve their upstream attribution and file-specific terms.

## Idriç-generated math boundary

`src/Hopf.idric` is the maintained mathematical source for `app/src/main/cpp/hopf_math.c` and `hopf_math.h`. The generated ICK C boundary is checked in and reproducibility is tested separately; the F-Droid Android build compiles those source artifacts without downloading an Idriç compiler. It builds the pinned ICK compiler from declared source libraries before compiling the application's C sources.

## Platform and toolchain

Android SDK/NDK components, Gradle, CMake, native_app_glue, system libraries, and OpenGL ES interfaces are external to this repository and remain under their upstream terms.

ICK and its pinned GCC reference provide the C frontend. The pinned ai-ci
Android compiler interface and bounded Bionic Fortify adapter are build inputs;
their upstream notices and terms remain in their source checkouts. Compiler
binaries are host build tools and are not packaged in the APK.
