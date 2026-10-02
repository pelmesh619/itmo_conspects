document.addEventListener('DOMContentLoaded', function () {
    if (window.location.host == "pelmeshke.gitlab.io" && ["/itmo_conspects", "/itmo_conspects/"].includes(window.location.pathname)) {
        const blockquotes = document.getElementsByTagName("blockquote");
        if (blockquotes.length == 0)
            return;

        const mirrorMessage = blockquotes[0];
        if (!mirrorMessage.innerText.includes("Также конспекты доступны"))
            return;

        mirrorMessage.innerHTML =
            "<p>Эта страница - зеркало репозитория на GitHub: " +
            "<a href=\"https://github.com/pelmesh619/itmo_conspects\">https://github.com/pelmesh619/itmo_conspects</a>" +
            "<br>Также конспекты доступны на " +
            "<a href=\"https://pelmesh619.github.io/itmo_conspects/\">https://pelmesh619.github.io/itmo_conspects/</a></p>";
    }
});