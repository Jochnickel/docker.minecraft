FROM ubuntu
RUN apt update && apt install -y wget curl unzip nano;

RUN printf '#!/bin/bash\nfunction update {\n  cp /root/current_version.url /root/old_version.url &>/dev/null\n  curl -s https://www.minecraft.net/en-us/download/server/bedrock | sed -En "s/.*?(http.*?linux.*?zip).*?/\\1/p" > /root/current_version.url\n  if cmp -s /root/old_version.url /root/current_version.url; then\n    echo Up to Date!\n  else\n    echo Updating...\n    cat /root/current_version.url | xargs wget -O /root/mc/current.zip\n    mv /root/mc/server.properties /root/mc/server.properties.backup &>/dev/null\n    cd /root/mc && unzip -o /root/mc/current.zip\n    mv /root/mc/server.properties.backup /root/mc/server.properties.backup &>/dev/null\n  fi\n  rm /root/old_version.url\n}\n\nif [ ! -e /root/mc/bedrock_server ]; then\n  mkdir /root/mc\n  touch /root/current_version.url\n  update\n  nano /root/mc/server.properties\n  cd /root/mc\n  echo\n  echo Start server? Type /run/mc/bedrock_server\n  echo\n  bash\n\nelse\n  update\n\n  cd /root/mc\n  LD_LIBRARY_PATH=/root/mc/\n/root/mc/bedrock_server\nfi\n' > /root/run.sh && chmod +x /root/run.sh

ENTRYPOINT /root/run.sh
EXPOSE 19132/udp
EXPOSE 19133/udp
