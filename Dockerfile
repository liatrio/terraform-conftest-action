FROM openpolicyagent/conftest:v0.41.0

COPY policy        /policy
COPY tests         /tests
COPY conftest.toml /conftest.toml

ENTRYPOINT ["conftest", "-c", "/conftest.toml", "test", "-p", "/policy", "-d", "/policy/data"]
