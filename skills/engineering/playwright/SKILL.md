---
name: playwright
description: Browser automation for web testing with Playwright
---

# Playwright Skill - Browser Automation

Use Playwright for browser automation, web testing, and scraping.

## Capabilities

- **Navigation** - Go to pages, click buttons, fill forms
- **Assertions** - Verify content, elements, states
- **Testing** - Run tests, capture screenshots, record videos
- **Scraping** - Extract data from web pages

## Usage

```bash
playwright <command> [options]

Commands:
  open <url>              - Open a new browser page
  click <selector>        - Click an element
  fill <selector> <text>  - Fill an input field
  screenshot <path>       - Take a screenshot
  html <selector?>        - Get page/source HTML
  goto <url>              - Navigate to URL
  exit                    - Close browser
```

## Examples

```bash
# Open a page
playwright open https://example.com

# Click an element
playwright click "text=Get Started"

# Fill a form
playwright fill "#email" "test@example.com"

# Take screenshot
playwright screenshot /tmp/page.png

# Get HTML
playwright html ".container"

# Navigate
playwright goto https://example.com
```

## Code Example

```javascript
import { chromium } from 'playwright';

const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto('https://example.com');
await page.click('text=More information...');
await page.screenshot({ path: 'example.png' });
await browser.close();
```

## Setup

```bash
npm install -D @playwright/test
npx playwright install chromium
```

## Resources

- [Playwright Docs](https://playwright.dev/)
- [Test Generator](https://playwright.dev/docs/test-generator)
