#!/bin/bash

# 检查是否输入了两个参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <user_list_file> <default_password>"
    exit 1
fi

USER_LIST_FILE="$1"
DEFAULT_PASSWORD="$2"
SKIPPED_USERS=()

# 检查 student 组是否存在
if ! getent group student > /dev/null; then
    sudo groupadd student
else
    echo "Group 'student' already exists, skipping creation."
fi

# 读取用户列表并创建用户
while IFS= read -r line; do
    echo "Processing: ${line}"
    user=${line%%\,*}
    echo "User: ${user}"

    if [ -d "/home/$user" ]; then
        echo "Skipping existing user: $user"
        SKIPPED_USERS+=("$user")
    else
        sudo useradd -m "$user" -s /bin/bash --badnames
        sleep 0.5 # 避免某些用户创建后无法登录的问题
	sudo mkdir /home/$usr/labs
	sudo chown $user:$user /home/$user/labs
	echo " $user created"

        sudo usermod -a -G pi,netdev,gpio,users,plugdev,dialout,input,student "$user"
        groups "$user"

        # 设置用户密码
        echo "$user:$DEFAULT_PASSWORD" | sudo chpasswd

        # 强制用户下次登录时修改密码
        sudo chage -d 0 "$user"

        echo "User $user added successfully."
    fi
done < "$USER_LIST_FILE"

# 输出所有跳过的用户
if [ "${#SKIPPED_USERS[@]}" -ne 0 ]; then
    echo "\nSkipped users:"
    printf '%s\n' "${SKIPPED_USERS[@]}"
else
    echo "\nNo users were skipped."
fi

