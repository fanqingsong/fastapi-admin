FROM python:3.9 as builder
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN mkdir -p /fastapi-admin
RUN echo 1
WORKDIR /fastapi-admin
COPY pyproject.toml poetry.lock /fastapi-admin/
ENV POETRY_VIRTUALENVS_CREATE false
RUN pip install  -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip && pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple poetry && poetry install --no-root
COPY . /fastapi-admin
RUN poetry source add --priority=default mirrors https://pypi.tuna.tsinghua.edu.cn/simple/
RUN poetry install && make compile

FROM python:3.9-slim
WORKDIR /fastapi-admin
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /fastapi-admin /fastapi-admin
