self.addEventListener('install', function (event) {
  console.log('Service worker is installed!')
});

self.addEventListener('activate', function (event) {
  console.log('Service worker is activated!')
});

self.addEventListener('fetch', function (event) {
  if (!event.request.url.match(/assets|packs/)) {
    return;
  }

  caches.match(event.request).then((res) => {
    return res || fetch(event.request).then((response) => {
      return caches.open("v1").then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    });
  });
});

