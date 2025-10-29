(function() {
    const targetWord = 'subway';
    let buffer = '';
  
    const wrapper = document.createElement('div');
    wrapper.id = 'subway-easter-egg';
    wrapper.innerHTML = `
      <div class="subway-container">
        <video id="subway-player" width="161" height="371" loop>
          <source src="./assets/subway.mp4" type="video/mp4">
          Your browser does not support the video tag.
        </video>
        <button id="subway-close">×</button>
      </div>
    `;
  
    const style = document.createElement('style');
    style.textContent = `
      #subway-easter-egg {
        display: none;
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 9999;
        animation: fadeIn 0.5s ease forwards;
      }
      #subway-easter-egg .subway-container {
        position: relative;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 16px rgba(0,0,0,0.3);
        background: #000;
      }
      #subway-easter-egg video {
        display: block;
        border: none;
        border-radius: 10px;
      }
      #subway-close {
        position: absolute;
        top: 4px;
        right: 6px;
        background: rgba(0,0,0,0.6);
        color: white;
        border: none;
        font-size: 18px;
        line-height: 1;
        padding: 4px 8px;
        border-radius: 50%;
        cursor: pointer;
      }
      #subway-close:hover {
        background: rgba(255,0,0,0.8);
      }
      @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
      }
    `;
    

    window.addEventListener("load", () => {
      document.body.appendChild(wrapper);
      document.head.appendChild(style);
    });
  
    const video = wrapper.querySelector('#subway-player');
    const closeBtn = wrapper.querySelector('#subway-close');
  
    document.addEventListener('keydown', (e) => {
      if (/^[a-zA-Z]$/.test(e.key)) {
        buffer += e.key.toLowerCase();
        if (buffer.length > targetWord.length) buffer = buffer.slice(-targetWord.length);
        if (buffer === targetWord) {
          wrapper.style.display = 'block';
          video.play();
        }
      } else if (e.key === 'Escape') {
        wrapper.style.display = 'none';
        video.pause();
      }
    });
  
    closeBtn.addEventListener('click', () => {
      wrapper.style.display = 'none';
      video.pause();
    });
  })();