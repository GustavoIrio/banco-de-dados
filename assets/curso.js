/* =====================================================================
   curso.js — comportamento compartilhado das aulas, listas e referências.
   Componentes (todos ativados só por marcação HTML):

   • Deck de slides      <body class="deck"> com <section class="slide">
       → / Espaço / PgDn  próximo      ← / PgUp  anterior
       Home / End         início / fim  F  tela cheia
   • Resposta oculta     <div class="resposta">…</div>
       vira um botão "Mostrar resposta" (use data-rotulo="…" para mudar o texto)
   • Quiz                <div class="quiz"><p class="pergunta">…</p>
                           <ol><li>…</li><li data-certa>…</li></ol>
                           <div class="explica">…</div></div>
   • Cronômetro          <span class="timer" data-min="10"></span>
   • Realce de SQL       <pre><code class="sql">…</code></pre>
   ===================================================================== */
(function () {
  'use strict';

  /* ---------- Realce de SQL ---------- */
  var PALAVRAS = ('SELECT FROM WHERE AND OR NOT IN IS NULL LIKE BETWEEN EXISTS AS ON JOIN INNER LEFT RIGHT OUTER ' +
    'ORDER BY ASC DESC DISTINCT LIMIT CASE WHEN THEN ELSE END INSERT INTO VALUES UPDATE SET DELETE ' +
    'CREATE ALTER DROP TABLE DATABASE VIEW IF USE ADD COLUMN MODIFY CHANGE CONSTRAINT PRIMARY FOREIGN KEY ' +
    'REFERENCES UNIQUE DEFAULT AUTO_INCREMENT CHECK INT INTEGER DECIMAL VARCHAR CHAR TEXT DATE DATETIME ' +
    'BOOLEAN SHOW DESCRIBE TABLES DATABASES REPLACE CONCAT TRUNCATE CASCADE RESTRICT UNION ALL').split(' ');
  var RE = new RegExp("(--[^\\n]*)|('(?:[^']|'')*')|\\b(\\d+(?:\\.\\d+)?)\\b|\\b(" + PALAVRAS.join('|') + ")\\b", 'gi');

  function esc(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

  function realcar(el) {
    var txt = el.textContent, out = '', ult = 0, m;
    RE.lastIndex = 0;
    while ((m = RE.exec(txt))) {
      out += esc(txt.slice(ult, m.index));
      var cls = m[1] ? 'sql-com' : m[2] ? 'sql-str' : m[3] ? 'sql-num' : 'sql-kw';
      out += '<span class="' + cls + '">' + esc(m[0]) + '</span>';
      ult = m.index + m[0].length;
    }
    el.innerHTML = out + esc(txt.slice(ult));
  }

  /* ---------- Resposta oculta ---------- */
  function prepararResposta(div) {
    var btn = document.createElement('button');
    btn.className = 'btn';
    var rotulo = div.getAttribute('data-rotulo') || 'Mostrar resposta';
    btn.textContent = rotulo;
    div.hidden = true;
    div.parentNode.insertBefore(btn, div);
    btn.addEventListener('click', function () {
      div.hidden = !div.hidden;
      btn.textContent = div.hidden ? rotulo : 'Ocultar';
    });
  }

  /* ---------- Quiz ---------- */
  function prepararQuiz(quiz) {
    var explica = quiz.querySelector('.explica');
    if (explica) explica.hidden = true;
    Array.prototype.forEach.call(quiz.querySelectorAll('ol > li'), function (li) {
      var btn = document.createElement('button');
      btn.innerHTML = li.innerHTML;
      var certa = li.hasAttribute('data-certa');
      li.innerHTML = '';
      li.appendChild(btn);
      btn.addEventListener('click', function () {
        btn.classList.add(certa ? 'certa' : 'errada');
        if (certa && explica) explica.hidden = false;
      });
    });
  }

  /* ---------- Cronômetro ---------- */
  function prepararTimer(el) {
    var total = Math.round(parseFloat(el.getAttribute('data-min') || '5') * 60), resta = total, id = null;
    var btn = document.createElement('button');
    btn.className = 'timer';
    function pinta() {
      var m = Math.floor(resta / 60), s = resta % 60;
      btn.textContent = '⏱ ' + m + ':' + (s < 10 ? '0' : '') + s;
    }
    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      if (id) { clearInterval(id); id = null; btn.classList.remove('rodando'); return; }
      if (resta === 0) { resta = total; btn.classList.remove('fim'); pinta(); return; }
      btn.classList.add('rodando');
      id = setInterval(function () {
        resta -= 1; pinta();
        if (resta <= 0) { clearInterval(id); id = null; btn.classList.remove('rodando'); btn.classList.add('fim'); }
      }, 1000);
    });
    btn.title = 'Clique para iniciar/pausar';
    pinta();
    el.replaceWith(btn);
  }

  /* ---------- Deck ---------- */
  function prepararDeck() {
    var slides = Array.prototype.slice.call(document.querySelectorAll('.slide'));
    if (!slides.length) return;
    var atual = 0;

    // Slides com vários quizzes soltos: coloca-os lado a lado
    slides.forEach(function (s) {
      var qs = Array.prototype.filter.call(s.children, function (el) { return el.classList.contains('quiz'); });
      if (qs.length < 2) return;
      var grade = document.createElement('div');
      grade.className = 'grade-quiz';
      grade.style.gridTemplateColumns = 'repeat(' + qs.length + ', 1fr)';
      s.insertBefore(grade, qs[0]);
      qs.forEach(function (q) { grade.appendChild(q); });
    });

    var barra = document.createElement('div'); barra.className = 'progresso';
    var rod = document.createElement('div'); rod.className = 'rodape';
    rod.innerHTML = '<a href="../index.html" title="Voltar ao plano do curso">◂ curso</a>' +
      '<span class="titulo"></span>' +
      '<button data-acao="tela" title="Tela cheia (F)">⛶</button>' +
      '<button data-acao="ant" title="Anterior (←)">◂</button>' +
      '<span class="conta"></span>' +
      '<button data-acao="prox" title="Próximo (→)">▸</button>';
    document.body.appendChild(barra); document.body.appendChild(rod);
    rod.querySelector('.titulo').textContent = document.title;

    function mostra(n, semHash) {
      atual = Math.max(0, Math.min(slides.length - 1, n));
      slides.forEach(function (s, i) { s.classList.toggle('ativo', i === atual); });
      rod.querySelector('.conta').textContent = (atual + 1) + ' / ' + slides.length;
      barra.style.width = ((atual + 1) / slides.length * 100) + '%';
      slides[atual].scrollTop = 0;
      if (!semHash) history.replaceState(null, '', '#' + (atual + 1));
    }
    function telaCheia() {
      if (document.fullscreenElement) document.exitFullscreen();
      else if (document.documentElement.requestFullscreen) document.documentElement.requestFullscreen();
    }

    rod.addEventListener('click', function (e) {
      var a = e.target.getAttribute && e.target.getAttribute('data-acao');
      if (a === 'ant') mostra(atual - 1);
      if (a === 'prox') mostra(atual + 1);
      if (a === 'tela') telaCheia();
    });
    document.addEventListener('keydown', function (e) {
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      var k = e.key;
      if (k === 'ArrowRight' || k === 'PageDown' || k === ' ') { e.preventDefault(); mostra(atual + 1); }
      else if (k === 'ArrowLeft' || k === 'PageUp') { e.preventDefault(); mostra(atual - 1); }
      else if (k === 'Home') mostra(0);
      else if (k === 'End') mostra(slides.length - 1);
      else if (k === 'f' || k === 'F') telaCheia();
    });
    window.addEventListener('hashchange', function () {
      var n = parseInt(location.hash.slice(1), 10);
      if (n) mostra(n - 1, true);
    });
    var ini = parseInt(location.hash.slice(1), 10);
    mostra(ini ? ini - 1 : 0, true);
  }

  /* ---------- Diagnóstico: abrir a aula com ?medir lista os slides que não cabem na tela ---------- */
  function medir() {
    var linhas = [];
    Array.prototype.forEach.call(document.querySelectorAll('.slide'), function (s, i) {
      document.querySelectorAll('.slide.ativo').forEach(function (x) { x.classList.remove('ativo'); });
      s.classList.add('ativo');
      var sobra = s.scrollHeight - s.clientHeight;
      var larg = s.scrollWidth - s.clientWidth;
      if (sobra > 2 || larg > 2) linhas.push('slide ' + (i + 1) + ': +' + sobra + 'px altura, +' + larg + 'px largura — ' +
        ((s.querySelector('h1,h2') || {}).textContent || ''));
    });
    var pre = document.createElement('pre');
    pre.id = 'medicao';
    pre.textContent = linhas.length ? linhas.join('\n') : 'todos os slides cabem';
    document.body.appendChild(pre);
  }

  document.addEventListener('DOMContentLoaded', function () {
    Array.prototype.forEach.call(document.querySelectorAll('code.sql'), realcar);
    Array.prototype.forEach.call(document.querySelectorAll('.resposta'), prepararResposta);
    Array.prototype.forEach.call(document.querySelectorAll('.quiz'), prepararQuiz);
    Array.prototype.forEach.call(document.querySelectorAll('.timer'), prepararTimer);
    if (document.body.classList.contains('deck')) prepararDeck();
    if (/[?&]medir\b/.test(location.search)) medir();
  });
})();
