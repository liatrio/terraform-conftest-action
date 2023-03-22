FROM openpolicyagent/conftest:v0.39.2

COPY entrypoint.sh /entrypoint.sh

COPY policy policy

ENTRYPOINT ["/entrypoint.sh"]
