#!/bin/bash

# 私有仓库地址
PRIVATE_REGISTRY="registry.cn-hangzhou.aliyuncs.com/your-repo"

# 检查输入参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <image>:<tag>"
    echo "Example: $0 mysql:8.0"
    exit 1
fi

# 获取镜像名称和标签
IMAGE="$1"
IMAGE_NAME=$(echo "$IMAGE" | cut -d ':' -f 1)
IMAGE_TAG=$(echo "$IMAGE" | cut -d ':' -f 2)

if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="latest"
fi

# 提取镜像的最后一级名称
LAST_PART=$(basename "$IMAGE_NAME")

# 拼接私有仓库镜像地址
PRIVATE_IMAGE="$PRIVATE_REGISTRY/$LAST_PART:$IMAGE_TAG"

# 拉取镜像
echo "Pulling image from private registry: $PRIVATE_IMAGE"
docker pull "$PRIVATE_IMAGE"

if [ $? -ne 0 ]; then
    echo "Failed to pull image from private registry."
    exit 2
fi

# 打标签为原版名称
echo "Tagging image: $PRIVATE_IMAGE as $IMAGE"
docker tag "$PRIVATE_IMAGE" "$IMAGE"

echo "Done. Image $IMAGE is ready for use."
