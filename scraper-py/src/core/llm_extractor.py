"""LLM-based data extraction utility using Crawl4AI."""

import json
import re
from typing import Any, TypeVar

from pydantic import BaseModel

from .config import settings

T = TypeVar("T", bound=BaseModel)


class LLMExtractor:
    """Base class for LLM-based web data extraction.

    Uses Crawl4AI with OpenRouter to extract structured data from web pages.
    """

    def __init__(
        self,
        model: str | None = None,
        api_key: str | None = None,
    ):
        self.model = model or settings.llm_model
        self.api_key = api_key or settings.openrouter_api_key

        if not self.api_key:
            raise ValueError(
                "OpenRouter API key required. Set OPENROUTER_API_KEY in .env"
            )

    async def extract_from_url(
        self,
        url: str,
        schema: type[T],
        instruction: str,
    ) -> list[T]:
        """Extract structured data from a URL using LLM.

        Args:
            url: The URL to scrape
            schema: Pydantic model class defining the expected output structure
            instruction: Natural language instruction for the LLM

        Returns:
            List of extracted items matching the schema
        """
        from crawl4ai import (
            AsyncWebCrawler,
            BrowserConfig,
            CacheMode,
            CrawlerRunConfig,
            LLMConfig,
            LLMExtractionStrategy,
        )

        llm_config = LLMConfig(
            provider=self.model,
            api_token=self.api_key,
        )

        extraction_strategy = LLMExtractionStrategy(
            llm_config=llm_config,
            schema=schema.model_json_schema(),
            extraction_type="schema",
            instruction=instruction,
        )

        browser_config = BrowserConfig(headless=True, verbose=False)
        crawler_config = CrawlerRunConfig(
            cache_mode=CacheMode.BYPASS,
            extraction_strategy=extraction_strategy,
        )

        async with AsyncWebCrawler(config=browser_config) as crawler:
            result = await crawler.arun(url=url, config=crawler_config)

            if not result.extracted_content:
                return []

            try:
                data = json.loads(result.extracted_content)
                if isinstance(data, list):
                    return [schema.model_validate(item) for item in data]
                else:
                    return [schema.model_validate(data)]
            except (json.JSONDecodeError, Exception):
                return []

    async def extract_from_html(
        self,
        html: str,
        schema: type[T],
        instruction: str,
    ) -> list[T]:
        """Extract structured data from raw HTML using LLM.

        Args:
            html: Raw HTML content
            schema: Pydantic model class defining the expected output structure
            instruction: Natural language instruction for the LLM

        Returns:
            List of extracted items matching the schema
        """
        import re
        from litellm import completion

        # Clean HTML: remove scripts, styles, and compress whitespace
        cleaned = self._clean_html(html)

        # For raw HTML, use litellm directly instead of crawl4ai
        prompt = f"""Extract structured data from the following HTML content.

{instruction}

Return the data as a JSON array matching this schema:
{json.dumps(schema.model_json_schema(), indent=2)}

HTML Content:
{cleaned[:80000]}

Return ONLY valid JSON, no markdown formatting."""

        response = completion(
            model=self.model,
            api_key=self.api_key,
            messages=[{"role": "user", "content": prompt}],
            temperature=0,
        )

        content = response.choices[0].message.content
        if not content:
            return []

        # Strip markdown code blocks if present
        content = content.strip()
        if content.startswith("```"):
            content = content.split("\n", 1)[1]
        if content.endswith("```"):
            content = content.rsplit("```", 1)[0]
        content = content.strip()

        try:
            data = json.loads(content)
            if isinstance(data, list):
                return [schema.model_validate(item) for item in data]
            else:
                return [schema.model_validate(data)]
        except (json.JSONDecodeError, Exception):
            return []

    def _clean_html(self, html: str) -> str:
        """Remove scripts, styles, and compress whitespace from HTML."""
        # Remove script tags and content
        html = re.sub(r'<script[^>]*>.*?</script>', '', html, flags=re.DOTALL | re.IGNORECASE)
        # Remove style tags and content
        html = re.sub(r'<style[^>]*>.*?</style>', '', html, flags=re.DOTALL | re.IGNORECASE)
        # Remove HTML comments
        html = re.sub(r'<!--.*?-->', '', html, flags=re.DOTALL)
        # Remove SVG tags and content
        html = re.sub(r'<svg[^>]*>.*?</svg>', '', html, flags=re.DOTALL | re.IGNORECASE)
        # Remove noscript tags
        html = re.sub(r'<noscript[^>]*>.*?</noscript>', '', html, flags=re.DOTALL | re.IGNORECASE)
        # Compress multiple whitespace to single space
        html = re.sub(r'\s+', ' ', html)
        # Remove empty tags
        html = re.sub(r'<[^>]+>\s*</[^>]+>', '', html)
        return html.strip()
