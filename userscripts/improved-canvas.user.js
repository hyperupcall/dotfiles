// ==UserScript==
// @name        Improved Canvas
// @namespace   com.edwinkofler
// @match       https://*.instructure.com/*
// @grant       none
// @version     0.2.1
// @author      Edwin Kofler
// @icon        data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkAQMAAABKLAcXAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAZQTFRFAAAA5gMFU0+ykQAAAAJ0Uk5TANWAKutjAAABcElEQVR4nK2UsW3EMAxFKahQ6RE0ila5MVJF12Utp7o1NIJKFcYx/KTshM4hwB3iRniGzU+R/CSSJzAPOp7MzNfn6bII0cUgdKUZNYLutBktIwkFnjFGZN7CjFMGcgm8KtVBzD1yU+KNKrfI3VLeqPA1WuJRKN31kCfZEUUScjuxpbwTBIv8HgbuD8EqFDcQBFETiSnUlTpIT3tnNDRWU6qIHRELVEAJOqCMZISWVRTKApL8chP1+qGX4FFU6FPVl9VozVamSfQsZQSrWtw3RMUHcoFG9egipTa/2P+o60Gl0Sy/NqSTld8aInTMTQBtjyn+pvtiGiUpZdOQUoCKafDtP6jeHig49b/y9Dfyt/WVcFXyFfTVfT+AUjt1hVzH6NW+5316CuLIZCGmTFbfp66jENt5Iv20+kn2U+4d4N1xco53lXecd6N3qnexdzjcnw/3+80wt0aYDfEbxW8bv4liTz+2lN9gfru9vCO/N+0Xy8HVRTq8+A0AAAAASUVORK5CYII=
// ==/UserScript==
(function () {
  'use strict';

const sheet = new CSSStyleSheet();
sheet.replaceSync(`
  #announcements-link, #syllabus-link {
	 background-color: lightpink;
  }

  #modules-link, #grades-link {
	 background-color: papayawhip;
  }

  .ic-app-course-menu > #sticky-container {
	 padding-inline: 12px 6px !important;
  }

  .ic-app-course-menu > #sticky-container li > a {
	 padding-block: 7px !important;
  }
`);
  document.adoptedStyleSheets.push(sheet);
})();
