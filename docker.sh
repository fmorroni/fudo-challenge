docker run -p 9292:9292 \
  -e JWT_SECRET=secret-key \
  -e EXTERNAL_API=https://23f0013223494503b54c61e8bee1190c.api.mockbin.io/ \
  fudo-challenge
