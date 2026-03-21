# IIIS LLM Router 使用指南

## 简介

IIIS LLM Router 是交叉信息研究院部署的统一大模型 API 代理，基于 LiteLLM 构建。通过一个统一入口，你可以访问 Claude、GPT、DeepSeek、Qwen、GLM 等 100+ 模型，使用标准的 OpenAI API 格式。

**统一入口：** `https://router.ai.iiis.co:9443`

---

## 1. 获取 API Key

1. 打开浏览器，访问 **https://router.ai.iiis.co:9443/ui**
2. 点击 **SSO Login**，使用 IIIS 统一身份认证登录（清华账号）
3. 登录后，在左侧菜单选择 **Virtual Keys**
4. 点击 **+ Create New Key**，填写 Key Name（如"我的科研脚本"）
5. 点击 **Create**，**立即复制并保存生成的 key**（格式为 `sk-...`，只显示一次！）

> ⚠️ Key 创建后只显示一次。如果丢失，删除旧 key 重新创建即可。

---

## 2. 可用模型

### Claude 系列（Anthropic）

| 模型名称 | 说明 | 推荐场景 |
|---|---|---|
| `claude-sonnet-4-6` | 性价比最优 ⭐ | **日常首选** |
| `claude-opus-4-6` | 最强推理 | 复杂推理、难题 |
| `claude-haiku-4-5-20251001` | 最快响应 | 简单任务、批量处理 |
| `claude-sonnet-4-5-20250929` | 上代旗舰 | 通用 |

> 💡 Claude 模型支持两种前缀写法：`claude-sonnet-4-6` 和 `aws/claude-sonnet-4-6` 等价。

### GPT 系列（OpenAI）

| 模型名称 | 说明 |
|---|---|
| `azure/gpt-5.4` | 最新 GPT |
| `azure/gpt-5.2` | 稳定版 |
| `azure/o3` | 推理模型（数学/逻辑） |

### 国产模型

| 模型名称 | 说明 |
|---|---|
| `infi/deepseek-v3.2` | DeepSeek V3.2 |
| `infi/deepseek-r1` | DeepSeek R1 推理 |
| `infi/qwen3-235b-a22b` | Qwen3 最大版 |
| `infi/qwen3-32b` | Qwen3 32B |
| `infi/glm-5` | GLM-5 |
| `infi/kimi-k2.5` | Kimi K2.5 |
| `infi/minimax-m2.5` | MiniMax M2.5 |

### 自部署模型（IIIS 集群 GPU）

| 模型名称 | 说明 |
|---|---|
| `iiis/qwen3.5-27b` | Qwen3.5 27B |
| `iiis/qwen3-vl` | Qwen3 视觉模型 |
| `iiis/minicpm-o` | MiniCPM-o 多模态 |

> 完整列表：`curl -H "Authorization: Bearer sk-你的key" https://router.ai.iiis.co:9443/v1/models`

---

## 3. 客户端配置

### 3.1 Claude Code（Anthropic 官方 CLI）

Claude Code 使用 Anthropic 原生 API 格式（不是 OpenAI 格式）。配置方式：

```bash
# 设置环境变量
export ANTHROPIC_BASE_URL="https://router.ai.iiis.co:9443/anthropic"
export ANTHROPIC_API_KEY="sk-你的API-Key"

# 启动 Claude Code
claude
```

或者在 `~/.claude/settings.json` 中配置：

```json
{
  "apiBaseUrl": "https://router.ai.iiis.co:9443/anthropic",
  "apiKey": "sk-你的API-Key"
}
```

**可用模型：** `claude-sonnet-4-6`、`claude-opus-4-6`、`claude-haiku-4-5-20251001` 等（不需要 `aws/` 前缀）。

**切换模型：**

```bash
claude --model claude-opus-4-6
```

### 3.2 Codex（OpenAI 官方 CLI）

Codex 使用 OpenAI Responses API 格式。配置方式：

```bash
export OPENAI_BASE_URL="https://router.ai.iiis.co:9443/v1"
export OPENAI_API_KEY="sk-你的API-Key"

# 启动 Codex
codex
```

**可用模型：** `azure/gpt-5.4`、`azure/o3` 等。

### 3.3 Cursor

在 Cursor 设置中配置自定义 API：

1. 打开 Cursor → Settings → Models
2. 找到 **OpenAI API Key** 部分
3. 填写：
   - **API Key：** `sk-你的API-Key`
   - **Base URL：** `https://router.ai.iiis.co:9443/v1`
4. 在模型选择列表中手动添加模型名，如 `claude-sonnet-4-6` 或 `azure/gpt-5.4`

> ⚠️ Cursor 部分功能可能需要特定模型支持。推荐使用 `claude-sonnet-4-6` 作为主力模型。

### 3.4 OpenClaw

在 OpenClaw 配置中添加 provider：

**OpenAI 格式（适用于 GPT/DeepSeek/Qwen 等）：**

```bash
openclaw config set providers.iiis.baseUrl "https://router.ai.iiis.co:9443/v1"
openclaw config set providers.iiis.apiKey "sk-你的API-Key"

# 添加模型
openclaw config set models.iiis/azure/gpt-5.4 '{"provider":"iiis"}'
openclaw config set models.iiis/deepseek-v3.2 '{"provider":"iiis","model":"infi/deepseek-v3.2"}'
```

**Anthropic 原生格式（适用于 Claude，推荐，延迟更低）：**

```bash
openclaw config set providers.iiis/aws.baseUrl "https://router.ai.iiis.co:9443/anthropic"
openclaw config set providers.iiis/aws.apiKey "sk-你的API-Key"
openclaw config set providers.iiis/aws.api "anthropic-messages"

# 添加模型
openclaw config set models.iiis/aws/claude-sonnet-4-6 '{"provider":"iiis/aws"}'
openclaw config set models.iiis/aws/claude-opus-4-6 '{"provider":"iiis/aws"}'
```

> 💡 Claude 模型走 Anthropic 原生格式（`/anthropic/v1/messages`）比 OpenAI 格式（`/v1/chat/completions`）延迟低 2-3 倍。

### 3.5 Continue（VS Code AI 插件）

编辑 `~/.continue/config.yaml`：

```yaml
models:
  - model: claude-sonnet-4-6
    title: Claude Sonnet
    provider: openai
    apiBase: https://router.ai.iiis.co:9443/v1
    apiKey: sk-你的API-Key

  - model: azure/gpt-5.4
    title: GPT-5.4
    provider: openai
    apiBase: https://router.ai.iiis.co:9443/v1
    apiKey: sk-你的API-Key
```

---

## 4. 编程接口

### 4.1 OpenAI Python SDK

```bash
pip install openai
```

**基本调用：**

```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-你的API-Key",
    base_url="https://router.ai.iiis.co:9443/v1"
)

response = client.chat.completions.create(
    model="claude-sonnet-4-6",
    messages=[
        {"role": "user", "content": "你好，请介绍一下自己"}
    ]
)

print(response.choices[0].message.content)
```

**流式输出：**

```python
stream = client.chat.completions.create(
    model="claude-sonnet-4-6",
    messages=[{"role": "user", "content": "写一首关于人工智能的诗"}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
```

**多轮对话：**

```python
messages = [
    {"role": "system", "content": "你是一个有帮助的助手。"},
    {"role": "user", "content": "什么是 transformer？"},
]

response = client.chat.completions.create(
    model="claude-sonnet-4-6",
    messages=messages
)

# 继续对话
messages.append({"role": "assistant", "content": response.choices[0].message.content})
messages.append({"role": "user", "content": "它和 RNN 的区别是什么？"})

response2 = client.chat.completions.create(model="claude-sonnet-4-6", messages=messages)
```

**图片理解（Vision）：**

```python
response = client.chat.completions.create(
    model="claude-sonnet-4-6",
    messages=[{
        "role": "user",
        "content": [
            {"type": "text", "text": "描述这张图片"},
            {"type": "image_url", "image_url": {
                "url": "https://example.com/image.jpg"
            }}
        ]
    }]
)
```

**环境变量方式（推荐，避免硬编码 key）：**

```bash
# ~/.bashrc 或 ~/.zshrc
export OPENAI_API_KEY="sk-你的API-Key"
export OPENAI_BASE_URL="https://router.ai.iiis.co:9443/v1"
```

```python
from openai import OpenAI
client = OpenAI()  # 自动读取环境变量
```

### 4.2 Anthropic Python SDK（原生格式）

如果你的代码直接使用 Anthropic SDK，也可以直接对接：

```bash
pip install anthropic
```

```python
import anthropic

client = anthropic.Anthropic(
    api_key="sk-你的API-Key",
    base_url="https://router.ai.iiis.co:9443/anthropic"
)

message = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude!"}
    ]
)

print(message.content[0].text)
```

### 4.3 LangChain

```bash
pip install langchain-openai
```

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="claude-sonnet-4-6",
    api_key="sk-你的API-Key",
    base_url="https://router.ai.iiis.co:9443/v1",
)

# 简单调用
response = llm.invoke("什么是量子计算？")
print(response.content)
```

**带 Chain 的用法：**

```python
from langchain_core.prompts import ChatPromptTemplate

prompt = ChatPromptTemplate.from_messages([
    ("system", "你是一个{domain}领域的专家。"),
    ("user", "{question}")
])

chain = prompt | llm

response = chain.invoke({
    "domain": "机器学习",
    "question": "解释一下 attention 机制"
})
print(response.content)
```

### 4.4 LlamaIndex

```bash
pip install llama-index-llms-openai-like
```

```python
from llama_index.llms.openai_like import OpenAILike

llm = OpenAILike(
    model="claude-sonnet-4-6",
    api_key="sk-你的API-Key",
    api_base="https://router.ai.iiis.co:9443/v1",
    is_chat_model=True,
)

response = llm.complete("什么是 RAG？")
print(response)
```

### 4.5 curl

```bash
curl -s https://router.ai.iiis.co:9443/v1/chat/completions \
  -H "Authorization: Bearer sk-你的API-Key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-6",
    "messages": [{"role": "user", "content": "Hello!"}]
  }' | python3 -m json.tool
```

### 4.6 TypeScript / Node.js

```bash
npm install openai
```

```typescript
import OpenAI from 'openai';

const client = new OpenAI({
    apiKey: 'sk-你的API-Key',
    baseURL: 'https://router.ai.iiis.co:9443/v1',
});

const response = await client.chat.completions.create({
    model: 'claude-sonnet-4-6',
    messages: [{ role: 'user', content: 'Hello!' }],
});

console.log(response.choices[0].message.content);
```

---

## 5. 管理 API Key

### 查看用量

登录 https://router.ai.iiis.co:9443/ui → **Usage** 页面：
- 每日请求数量和 Token 消耗量
- 按模型分类的用量明细

### 删除/重新生成 Key

**API Keys** 页面 → 点击 key 旁的删除按钮立即撤销。key 泄露时请立即删除并创建新 key。

---

## 6. 常见问题

**Q: 提示 Authentication Error？**
确保 API Key 正确。OpenAI SDK 用 `api_key` 参数，curl 用 `-H "Authorization: Bearer sk-..."`。

**Q: 模型返回超时？**
大模型（如 Opus）首次响应可能需要 10-30 秒。建议使用 `stream=True`，或设置超时 `client = OpenAI(..., timeout=120)`。

**Q: 能在集群 Pod 里用吗？**
可以，集群内直接访问，不需要代理。

**Q: 网络注意事项？**
- 校内网络（有线/eduroam）：直接访问
- 校外：通过清华 VPN 后访问
- ⚠️ **不要**设置 HTTP_PROXY：这是内网服务，设代理反而无法访问

**Q: Claude Code 用 OpenAI 格式还是 Anthropic 格式？**
Claude Code 必须使用 Anthropic 原生格式（`/anthropic` 端点）。普通 Python 脚本两种都可以，但 Anthropic 格式延迟更低。

**Q: 和直接调用 API 有什么区别？**
- ✅ 不需要注册海外账号、绑信用卡
- ✅ 统一格式，切换模型只改 model 名
- ✅ 国内直连，无需科学上网
- ✅ 免费使用（院内资源）

---

## 联系方式

遇到问题或需要新模型？联系管理员：徐葳
