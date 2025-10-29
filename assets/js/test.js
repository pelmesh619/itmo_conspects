(function() {
    const targetWord = 'test';
    let buffer = '';
  
    document.addEventListener('keydown', (e) => {
      if (/^[a-zA-Z]$/.test(e.key)) {
        buffer += e.key.toLowerCase();
        if (buffer.length > targetWord.length) buffer = buffer.slice(-targetWord.length);
        if (buffer === targetWord) {
          console.log("Success")
        }
      }
    });
  })();