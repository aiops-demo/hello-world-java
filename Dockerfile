FROM adoptopenjdk/openjdk8:ubi-jre
RUN mkdir /opt/app
COPY target/app.jar /opt/app/app.jar
ENV PORT 8080
EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java -jar /opt/app/app.jar" ]
