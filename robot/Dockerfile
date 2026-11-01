FROM ros:jazzy-ros-base
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential python3-colcon-common-extensions \
    ros-jazzy-foxglove-bridge ros-jazzy-tf2-ros \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /ws
RUN mkdir -p src && git clone --depth 1 https://github.com/ldrobotSensorTeam/ldlidar_stl_ros2 src/ldlidar_stl_ros2
# Jazzy/GCC13 patch: log_module.cpp uses pthread_mutex_* without including <pthread.h>
RUN sed -i "1i #include <pthread.h>" src/ldlidar_stl_ros2/ldlidar_driver/src/logger/log_module.cpp
RUN . /opt/ros/jazzy/setup.sh && colcon build --symlink-install
# rosbridge + rosapi for ros-mcp-server (WebSocket on :9090)
RUN apt-get update && apt-get install -y --no-install-recommends ros-jazzy-rosbridge-suite && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
