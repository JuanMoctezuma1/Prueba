#!/bin/bash

USERS_TO_REVOKE=(
    "juanmejiam"
)

# Loop through each user in the list
for user in "${USERS_TO_REVOKE[@]}"; do
    echo "Processing user: $user"
    
    if id "$user" &>/dev/null; then
        user_home=$(getent passwd "$user" | cut -d: -f6)
        authorized_keys="$user_home/.ssh/authorized_keys"
        
        if [ -d "$user_home/.ssh" ]; then
            if [ -f "$authorized_keys" ]; then
                
                if rm -f "$authorized_keys" 2>/dev/null; then
                    echo -e "Successfully removed SSH access for '$user'${NC}"
                    echo -e "  File removed: $authorized_keys"
                else
                    echo -e "Failed to remove authorized_keys for '$user'${NC}"
                fi
            else
                echo -e "User '$user' has no authorized_keys file${NC}"
            fi
        else
            echo -e "User '$user' has no .ssh directory${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ User '$user' does not exist, skipping...${NC}"
    fi
    
    echo ""
done

exit 0
