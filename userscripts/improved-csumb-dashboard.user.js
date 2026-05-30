// ==UserScript==
// @name        Improved CSUMB Dashboard
// @namespace   com.edwinkofler
// @match       https://my.csumb.edu/dashboard*
// @grant       none
// @version     0.2.1
// @author      Edwin Kofler
// @icon        data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkAQMAAABKLAcXAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAZQTFRF/P39ZXN/iSt1aAAAAb9JREFUeJzt0jFL5EAUAOA3SdApxCRYXATZXVcLi4Nbm6vE6CoWNoK/YEWwvS0txMnJwp2CLDYWNquVlbWlEQWFK078Axu1FVytosa8e7NJ3NnG7jpfEd6XeZk3kxmAz/ggKirysa8I8akDMx5EryMPfnRK1wF6gwxMZt88Vfms1JSJ20o1SS1AhO/SETBTFYwSw5d0EvpsguGzpypMJtXppcPwMenf336Ku2RsKNnUaaDI9KtpAxm9XrIYL1VF2b4OJVCj2qVWlwIl17rF1Mr+zasspZYL278z0YIfDi8zTQE/Oj7vNN6M4tlMDuysxsVMOWaH8+8y9RFfl2JvrfgVb0XoIp2arg+wLR0xIvlgsO+wp5EEYgAcRnlOq6dyVr9OfjH/NCKUss7Hijafr0fY/BtAoTY2YvPF+hs2LgIY/nU/fsOvpWhsGAxHS0QdpkHr0ZzdBrZVpv6aVWvLI4G/0ZabqFK2annRdGWl2bTmbEOqQXJ2+Ird55Lo3sxYB3xlnLvixKXrtHSzH87lHJThQ+G0UC33WYhC7rakFeEMCihI9LuMZfbT83EdpcxQPNClk4rohANYgwn4jP8R/wAbHMszCIu7vwAAAABJRU5ErkJggg==
// ==/UserScript==
(function () {
  'use strict';

  const sheet = new CSSStyleSheet();
sheet.replaceSync(`
  .dashboard-node .node-leaf {
	 max-width: 1400px !important;
  }

  widget-container.dashboard-widgets .card.widget {
	 margin: 4px !important;
  }
`);
  document.adoptedStyleSheets.push(sheet);
})();
