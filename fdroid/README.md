# F-Droid release path

The Android project produces an unsigned release APK from public source,
pinned ICK C frontends and the declared NDK r29. Its single APK retains
`armeabi-v7a`, `arm64-v8a` and `x86_64`.

1. Keep `versionCode` and `versionName` in `app/build.gradle.kts` equal to the tagged public release.
2. Run the `F-Droid release build` workflow; it builds `assembleRelease`, verifies package identity and all three native ABIs, and retains the unsigned APK as evidence.
3. The separate Idriç reproducibility CI remains authoritative for the generated math boundary. F-Droid receives the pinned ICK and ai-ci repositories as declared source libraries, then bootstraps and qualifies each ABI compiler during `build`, before Gradle compiles the application. The source-library preparation fetches ICK's pinned GCC submodule; application compilation does not fetch an undeclared compiler binary.
4. Tag the exact release commit `v<versionName>`.
5. Replace `FULL_COMMIT_HASH` in the metadata template with that commit and submit it as `metadata/org.isomorphisms.hopf.yml` to fdroiddata, together with the `srclibs/ICK.yml` and `srclibs/AICI.yml` definitions if those names are not already registered there.

F-Droid rebuilds and signs the application itself. The upstream unsigned APK is only a reproducibility gate.

The metadata follows F-Droid's source-library and build-phase interfaces:
https://f-droid.org/en/docs/Build_Metadata_Reference/. `sudo` provisions the
compiler bootstrap dependencies; `prebuild` configures inputs; all compiler
compilation happens in `build`. The pinned shared Makefile verifies ICK and
its GCC submodule revisions before materializing source. It qualifies literal
glyph arithmetic, Bionic headers and the API26 Fortify2 adapter for each ABI.
The installed stages live at the exact paths consumed by CMake.

The existing placeholder for the application's future release commit is
intentional. This migration does not create a release tag or claim a completed
F-Droid-server rebuild. See [the source and toolchain evidence](../docs/division-migration.md).
