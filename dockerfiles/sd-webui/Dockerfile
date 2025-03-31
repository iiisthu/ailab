FROM harbor.ai.iiis.co:9443/zhaoyue/lab5:v4


WORKDIR /sd-repo
RUN pip install pydantic==1.10.19
COPY . /sd-repo/

CMD ["bash", "run.sh"]