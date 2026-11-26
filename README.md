# unitree_sdk2 release

Bloom packaging for [unitree_sdk2](https://github.com/unitreerobotics/unitree_sdk2), targeting ROS 2 Jazzy.
ROS package files are added from `master:overlay`; upstream sources are unchanged.

Update `version` and `release_tag` in `tracks.yaml` for each upstream update,
then generate release branches locally:

```bash
git-bloom-release jazzy
```

Bloom reapplies the overlay and exported patches on each release. Resolve any
patch conflicts and test the result. Each ROS distribution needs its own track.
This repository is not yet registered in rosdistro.
