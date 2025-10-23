# 音乐文件管理工具

这是一个用于管理音乐文件的工具集，主要功能是将网易云音乐的NCM格式文件转换为通用的MP3或FLAC格式。

## 功能特性

- **批量转换**: 支持批量转换NCM文件为MP3或FLAC格式
- **递归处理**: 可以递归处理子目录中的NCM文件
- **多种输出格式**: 支持MP3和FLAC输出格式
- **灵活配置**: 支持自定义输出目录和质量参数
- **详细日志**: 提供详细的转换过程信息

## 依赖要求

在使用转换脚本之前，需要安装 `ncmdump` 工具：

### macOS
```bash
brew install ncmdump
```

### Windows
从 [GitHub项目](https://github.com/taurusxin/ncmdump) 下载预编译二进制文件

### Linux
从 [GitHub项目](https://github.com/taurusxin/ncmdump) 下载或从源码编译

## 使用方法

### 基本用法

```bash
# 显示帮助信息
./ncmdump.sh -h

# 转换当前目录下的所有NCM文件为MP3
./ncmdump.sh

# 转换指定目录下的NCM文件
./ncmdump.sh -d ~/Music/网易云音乐

# 转换单个NCM文件
./ncmdump.sh -f music.ncm
```

### 高级选项

```bash
# 递归处理子目录
./ncmdump.sh -d ~/Music -r

# 指定输出目录
./ncmdump.sh -d ~/Music/网易云音乐 -o ~/Music/MP3

# 转换为FLAC格式
./ncmdump.sh -d ~/Music/网易云音乐 -t flac

# 显示详细输出
./ncmdump.sh -d ~/Music/网易云音乐 -v

# 只列出NCM文件，不进行转换
./ncmdump.sh -d ~/Music/网易云音乐 -l

# 自动确认所有提示
./ncmdump.sh -d ~/Music/网易云音乐 -y
```

### 命令行参数

| 参数 | 长参数 | 说明 |
|------|--------|------|
| `-h` | `--help` | 显示帮助信息 |
| `-d` | `--directory` | 指定包含NCM文件的目录（默认为当前目录） |
| `-f` | `--file` | 指定单个NCM文件进行转换 |
| `-o` | `--output` | 指定输出目录（默认为原文件所在目录） |
| `-r` | `--recursive` | 递归处理子目录中的NCM文件 |
| `-q` | `--quality` | 设置输出质量参数 |
| `-t` | `--type` | 设置输出格式：mp3 或 flac（默认为mp3） |
| `-l` | `--list` | 只列出NCM文件，不进行实际转换 |
| `-v` | `--verbose` | 显示详细输出信息 |
| `-y` | `--yes` | 自动确认所有提示 |

## 使用示例

### 示例1: 批量转换网易云音乐文件
```bash
# 将网易云音乐文件夹中的所有NCM文件转换为MP3
./ncmdump.sh -d ~/Music/网易云音乐 -o ~/Music/MP3 -t mp3 -v
```

### 示例2: 递归处理并转换为FLAC
```bash
# 递归处理所有子目录，转换为FLAC格式
./ncmdump.sh -d ~/Music -r -t flac -o ~/Music/FLAC
```

### 示例3: 预览模式
```bash
# 只查看有哪些NCM文件，不进行转换
./ncmdump.sh -d ~/Music/网易云音乐 -l
```

## 注意事项

1. **备份重要文件**: 在批量转换前，建议备份原始的NCM文件
2. **磁盘空间**: 确保有足够的磁盘空间存储转换后的文件
3. **文件权限**: 确保脚本有执行权限：`chmod +x ncmdump.sh`
4. **依赖检查**: 脚本会自动检查是否安装了ncmdump工具

## 故障排除

### 常见问题

1. **"未找到 ncmdump 命令"**
   - 确保已正确安装ncmdump工具
   - 检查PATH环境变量是否包含ncmdump的安装路径

2. **"文件不存在"**
   - 检查指定的文件或目录路径是否正确
   - 确保文件权限允许读取

3. **"转换失败"**
   - 检查NCM文件是否完整且未损坏
   - 尝试使用详细模式查看具体错误信息

### 获取帮助

如果遇到问题，可以：
1. 使用 `-h` 参数查看帮助信息
2. 使用 `-v` 参数查看详细的转换过程
3. 检查ncmdump工具的官方文档

## 许可证

本项目遵循相应的开源许可证。ncmdump工具请参考其官方项目的许可证条款。

## 相关链接

- [ncmdump GitHub项目](https://github.com/taurusxin/ncmdump)
- [网易云音乐](https://music.163.com/)
