document.addEventListener('DOMContentLoaded', async function () {
    const h1s = document.querySelectorAll('h1');
    if (!h1s && h1s.size() <= 2) {
        return;
    }
    const h1 = h1s[1];

    const currentPath = window.location.pathname;
    const domain = currentPath.replace(/^(.+\/\/.+?)\/.+$/, '$1');
    const metaPath = currentPath.replace(/_superconspect\.html?$/i, '.meta.json');
    const metaUrl = new URL(metaPath, window.location.href).href;

    try {
        const response = await fetch(metaUrl);
        if (!response.ok) {
            console.warn(`Meta file loading error: ${response.status} ${response.statusText}`);
            return;
        }
        const data = await response.json();

        const recommended = data.recommended || [];
        const seeAlso = data.seeAlso || [];

        const suggestionBlock = document.createElement('div');

        let block1 = null;
        if (recommended != []) {
            block1 = document.createElement('div');
            block1.style.border = '2px solid #2c3e50';
            block1.style.padding = '14px 18px';
            block1.style.margin = '12px 0';
            block1.style.borderRadius = '6px';
            block1.style.backgroundColor = '--bg-color';

            const title1 = document.createElement('p');
            title1.style.fontWeight = 'bold';
            title1.style.margin = '0 0 8px 0';
            title1.textContent = 'Для изучения этой дисциплины рекомендовано изучить эти курсы:';
            block1.appendChild(title1);

            const list1 = document.createElement('ul');
            list1.style.margin = '0';
            list1.style.paddingLeft = '20px';
            recommended.forEach(course => {
                const li = document.createElement('li');
                const a = document.createElement('a');
                a.textContent = course.title;
                a.href = course.link;
                li.appendChild(a);
                list1.appendChild(li);
            });
            block1.appendChild(list1);
            h1.insertAdjacentElement('afterend', block1);
        }

        if (seeAlso != []) {
            const block2 = document.createElement('div');
            block2.style.border = '2px solid #2c3e50';
            block2.style.padding = '14px 18px';
            block2.style.margin = '12px 0';
            block2.style.borderRadius = '6px';
            block2.style.backgroundColor = '--bg-color';

            const title2 = document.createElement('p');
            title2.style.fontWeight = 'bold';
            title2.style.margin = '0 0 8px 0';
            title2.textContent = 'Смотрите также:';
            block2.appendChild(title2);

            const list2 = document.createElement('ul');
            list2.style.margin = '0';
            list2.style.paddingLeft = '20px';
            seeAlso.forEach(course => {
                const li = document.createElement('li');
                const a = document.createElement('a');
                a.textContent = course.title;
                a.href = course.link;
                li.appendChild(a);
                list2.appendChild(li);
            });
            block2.appendChild(list2);
            (block1 || h1).insertAdjacentElement('afterend', block2);
        }
    } catch (error) {
        console.warn('Meta file could not be loaded:', error);
    }
});