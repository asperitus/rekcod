##
FROM alpine:3.9
RUN apk add --no-cache bash curl git openssh sudo wget

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["uname -a"]
##