# unitree_sdk2 release

Bloom packaging for [unitree_sdk2](https://github.com/unitreerobotics/unitree_sdk2), targeting ROS 2 Jazzy.
ROS package files are added from `master:overlay`; upstream sources are unchanged.
The CMake install fix is exported to `patches/release/jazzy/unitree_sdk2`.

Update `version` and `release_tag` in `tracks.yaml` for each upstream update,
then generate release branches locally:

```bash
git-bloom-release jazzy
```

Bloom reapplies the overlay and exported patches on each release. Resolve any
patch conflicts and test the result. Each ROS distribution needs its own track.
This repository is not yet registered in rosdistro.

The Ubuntu 24.04 amd64 deb builds, but is not ready for release:
- Its `libddsc.so` and `libddsc.so.0` conflict with `ros-jazzy-cyclonedds`.
- Exported CMake targets use `lib/`, but Debian installs libraries in `lib/x86_64-linux-gnu/`.
