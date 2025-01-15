document.addEventListener('DOMContentLoaded', function () {
    const topScroller = document.getElementById('top-scroller');
    const scrollThreshold = 400; 

    window.addEventListener('scroll', function () {
      if (window.scrollY > scrollThreshold) {
        topScroller.style.display = 'block';
      } else {
        topScroller.style.display = 'none';
      }
    });

    topScroller.addEventListener('click', function (e) {
      e.preventDefault(); 
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  });