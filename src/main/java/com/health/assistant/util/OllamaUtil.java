package com.health.assistant.util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class OllamaUtil {

    private static final String OLLAMA_URL = "http://localhost:11434/api/generate";

    /**
     * 调用 Ollama 生成内容
     * @param model 模型名称，如 deepseek-r1:7b
     * @param prompt 提示词
     * @return AI 生成的完整内容
     */
    public static String generate(String model, String prompt) {
        HttpURLConnection connection = null;
        try {
            // 构建 JSON 请求体（手动拼接，避免依赖 Gson）
            String jsonInput = "{\"model\": \"" + escapeJson(model) + "\", \"prompt\": \"" + escapeJson(prompt) + "\", \"stream\": false}";

            // 创建连接
            URL url = new URL(OLLAMA_URL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);
            connection.setConnectTimeout(60000);
            connection.setReadTimeout(120000);

            // 发送请求
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonInput.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // 读取响应
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    return parseResponse(response.toString());
                }
            } else {
                return "AI 调用失败：HTTP " + responseCode;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "AI 调用异常：" + e.getMessage();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    /**
     * 从 JSON 响应中提取 response 字段（简单解析，不依赖 Gson）
     */
    private static String parseResponse(String json) {
        // 查找 "response":" 后面的内容
        String key = "\"response\":\"";
        int start = json.indexOf(key);
        if (start == -1) {
            return "解析响应失败";
        }
        start += key.length();

        // 找到结束的引号，处理转义字符
        StringBuilder result = new StringBuilder();
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '\\' && i + 1 < json.length()) {
                char next = json.charAt(i + 1);
                if (next == 'n') {
                    result.append('\n');
                    i++;
                } else if (next == '"') {
                    result.append('"');
                    i++;
                } else if (next == '\\') {
                    result.append('\\');
                    i++;
                } else {
                    result.append(c);
                }
            } else if (c == '"') {
                break;
            } else {
                result.append(c);
            }
        }
        return result.toString();
    }

    /**
     * 转义 JSON 字符串中的特殊字符
     */
    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}