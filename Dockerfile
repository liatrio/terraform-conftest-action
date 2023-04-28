FROM openpolicyagent/conftest:v0.39.2

COPY policy        /policy
COPY tests         /tests
COPY conftest.toml /conftest.toml

ENTRYPOINT ["conftest", "test", "-p", "/policy", "-d", "/policy/data"]
