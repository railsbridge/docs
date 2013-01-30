## HTML Skeleton
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>Title</title>
      </head>
      <body>
    
      </body>
    </html>

## Headers
    <h1>Header</h1>
    <h2>Header</h2>
    <h2>Header</h2>
    <h4>Header</h4>
    <h5>Header</h5>
    <h6>Header</h6>

## Paragraphs and more
    <p>Paragraph content.</p>
    <em>emphasized content, styled italic by default</em>
    <strong>strong content, styled bold by default</strong>

## Images
    <img src="name-of-my-image.png">
    <img src="http://www.othersite.com/image-name.jpg">

## Links
    <a href="#anchor">Scroll to element on the current page with id "anchor"</a>
    <a href="my-other-page.html">Go to a page on my site</a>
    <a href="my-other-page.html" target="_blank">Open a new window for a page on my site</a>
    <a href="http://www.othersite.com/">Go to a page on some other site</a>
    <a href="http://www.othersite.com/" target="_blank">Open a new window for a page on some other site</a>

## Lists

Lists can be ordered (styled with numbers by default) or unordered (styled with bullets by default). Both contain list items with the actual content of the list.

    <ol>
      <li>First list item</li>
      <li>Second list item</li>
    </ol>

    <ul>
      <li>One list item</li>
      <li>Another list item</li>
    </ul>

Lists can be nested.

    <ul>
      <li>One list item
        <ul>
          <li>A list item nested under "One list item"</li>
          <li>Another nest list item</li>
        </ul>
      </li>
      <li>Another list item</li>
    </ul>

## Containers

Divs and spans are generic containers used to organize HTML. Often, they are given ids and classes so that they can be given specific styling.

    <div>The content in the div</div>
    <span>span content</span>

## Ids and Classes

Ids and classes provide a way to use CSS to target specific element(s). Many tags can have the same class. Only one tag can have a particular id. Any tag can be gi
an id and classes.</p>
    <tagname id="a-name-uniquely-identifying-this-element">content</tagname>
    <tagname class="one-class another-class">content</tagname>
