-- Copyright (C) 2026 IEEE UFG Computer Society contributors.
-- Distributed under the LaTeX Project Public License 1.3c or later.
-- See ../../LICENSE and ../MANIFEST.md.

local lfs = require("lfs")
local windows = os.type == "windows" or
  package.config:sub(1, 1) == "\\"
local separator = windows and ";" or ":"
local original_texinputs = os.getenv("TEXINPUTS") or ""

local function fail(message)
  io.stderr:write("Erro: " .. message .. "\n")
  os.exit(1)
end

local function join(...)
  return (table.concat({...}, "/"):gsub("\\", "/"))
end

local function canonical(path)
  local before = lfs.currentdir()
  local ok = lfs.chdir(path)
  if not ok then return nil end
  local result = lfs.currentdir():gsub("\\", "/")
  lfs.chdir(before)
  return result
end

local script = arg[0]:gsub("\\", "/")
local script_dir = script:match("^(.*)/[^/]+$") or "."
local scripts_dir = canonical(script_dir) or
  fail("diretório de scripts ausente")
local development = canonical(join(scripts_dir, ".."))
local root = canonical(join(development, ".."))
local documents = join(root, "documents")
local build = join(development, "build")
local document_build = join(build, "documents")
local texmfvar = join(build, "texmf-var")
local catalog = join(development, "templates/catalog.tsv")
local makefile = join(scripts_dir, "document.mk")

local function same_path(a, b)
  if windows then return a:lower() == b:lower() end
  return a == b
end

local function kind(path)
  local attributes = lfs.symlinkattributes(path)
  return attributes and attributes.mode
end

local function mkdir(path)
  path = path:gsub("\\", "/")
  if kind(path) == "directory" then return end
  local parent = path:match("^(.*)/[^/]+$")
  if parent and parent ~= path then mkdir(parent) end
  local ok, err = lfs.mkdir(path)
  if not ok then fail("não foi possível criar " .. path .. ": " .. err) end
end

local function names(path)
  local result = {}
  if kind(path) ~= "directory" then return result end
  for name in lfs.dir(path) do
    if name ~= "." and name ~= ".." then result[#result + 1] = name end
  end
  table.sort(result)
  return result
end

local function copy_file(source, target)
  local input = io.open(source, "rb")
  if not input then fail("não foi possível ler " .. source) end
  local output = io.open(target, "wb")
  if not output then
    input:close()
    fail("não foi possível criar " .. target)
  end
  while true do
    local chunk = input:read(65536)
    if not chunk then break end
    output:write(chunk)
  end
  input:close()
  output:close()
end

local function copy_tree(source, target)
  mkdir(target)
  for _, name in ipairs(names(source)) do
    local from, to = join(source, name), join(target, name)
    local mode = kind(from)
    if mode == "directory" then
      copy_tree(from, to)
    elseif mode == "file" then
      copy_file(from, to)
    else
      fail("item de modelo não suportado: " .. from)
    end
  end
end

local function remove_tree(path)
  local mode = kind(path)
  if mode == "directory" then
    for _, name in ipairs(names(path)) do
      remove_tree(join(path, name))
    end
    local ok, err = lfs.rmdir(path)
    if not ok then fail("não foi possível remover " .. path .. ": " .. err) end
  elseif mode then
    local ok, err = os.remove(path)
    if not ok then fail("não foi possível remover " .. path .. ": " .. err) end
  end
end

local function valid_name(name)
  if not name:match("^[A-Za-z0-9][A-Za-z0-9_-]*$") then
    fail("use apenas letras, números, hífen e sublinhado no identificador")
  end
  local base = name:upper()
  if base:match("^CON$") or base:match("^PRN$") or
      base:match("^AUX$") or base:match("^NUL$") or
      base:match("^COM[1-9]$") or base:match("^LPT[1-9]$") then
    fail("identificador reservado pelo Windows: " .. name)
  end
end

local function read_answer(prompt, default)
  io.write(prompt)
  io.flush()
  return io.read("*l") or default
end

local function templates()
  local result = {}
  local input = io.open(catalog, "r")
  if not input then fail("catálogo de modelos não encontrado") end
  for line in input:lines() do
    if not line:match("^#") and line ~= "" then
      local key, label, description = line:match("^([^|]+)|([^|]+)|(.+)$")
      if not key then fail("linha inválida no catálogo: " .. line) end
      result[#result + 1] = {key, label, description}
    end
  end
  input:close()
  if #result == 0 then fail("nenhum modelo cadastrado") end
  return result
end

local function print_templates(items)
  print("Modelos disponíveis:")
  for i, item in ipairs(items) do
    print(("  %d) %s\n     %s"):format(i, item[2], item[3]))
  end
end

local function document_names()
  local result = {}
  for _, name in ipairs(names(documents)) do
    if kind(join(documents, name)) == "directory" and
        kind(join(documents, name, "main.tex")) == "file" then
      result[#result + 1] = name
    end
  end
  return result
end

local function print_documents(items)
  if #items == 0 then
    print("Nenhum documento criado. Execute `make new`.")
    return
  end
  print("Documentos:")
  for i, name in ipairs(items) do print(("  %d) %s"):format(i, name)) end
end

local function choose_document(requested)
  local items = document_names()
  if #items == 0 then
    fail("nenhum documento criado; execute 'make new' primeiro")
  end
  if requested and requested ~= "" then
    valid_name(requested)
    if kind(join(documents, requested, "main.tex")) ~= "file" then
      fail("documento não encontrado: " .. requested)
    end
    return requested
  end
  if #items == 1 then return items[1] end
  print_documents(items)
  local answer = read_answer("\nSelecione um documento [1]: ", "1")
  local index = tonumber(answer == "" and "1" or answer)
  if not index or index % 1 ~= 0 or not items[index] then
    fail("selecione um número da lista")
  end
  return items[index]
end

local function document_path(requested)
  if not requested or requested == "" then
    fail("diretório de documento não informado")
  end
  local actual = canonical(requested)
  if not actual then fail("diretório não encontrado: " .. requested) end
  local name = actual:match("([^/]+)$")
  valid_name(name)
  if not same_path(actual:match("^(.*)/[^/]+$"), documents) then
    fail("o diretório deve estar diretamente dentro de documents/")
  end
  if kind(join(actual, "main.tex")) ~= "file" then
    fail("arquivo principal não encontrado em " .. requested)
  end
  return name
end

local function quote(value)
  if value:find('"') then fail("aspas em caminho não são suportadas") end
  return '"' .. value .. '"'
end

local function run(command, cwd)
  local before = lfs.currentdir()
  if cwd then lfs.chdir(cwd) end
  local ok = os.execute(command)
  if cwd then lfs.chdir(before) end
  if not ok then fail("comando falhou: " .. command) end
end

local function tex_environment()
  mkdir(texmfvar)
  local inputs = join(development, "tex/latex//") .. separator ..
    original_texinputs
  os.setenv("TEXINPUTS", inputs)
  os.setenv("TEXMFVAR", texmfvar)
end

local function latexmk(source, output, cwd)
  mkdir(output)
  tex_environment()
  local command = "latexmk -lualatex -interaction=nonstopmode " ..
    "-halt-on-error -outdir=" .. quote(output) .. " " .. quote(source)
  run(command, cwd)
end

local function build_document(name)
  valid_name(name)
  local source = join(documents, name)
  if kind(join(source, "main.tex")) ~= "file" then
    fail("arquivo principal não encontrado para " .. name)
  end
  local output = join(document_build, name)
  print("Compilando " .. name .. "...")
  latexmk("main.tex", output, source)
  if kind(join(output, "main.pdf")) ~= "file" then
    fail("PDF não encontrado após compilação de " .. name)
  end
  copy_file(join(output, "main.pdf"), join(source, "main.pdf"))
  print("\nPDF gerado em:\n  documents/" .. name .. "/main.pdf")
end

local function clean_document(name)
  valid_name(name)
  local output = join(document_build, name)
  local pdf = join(documents, name, "main.pdf")
  if not kind(output) and not kind(pdf) then
    print("Nenhum arquivo gerado para " .. name .. ".")
    return
  end
  if kind(output) and kind(output) ~= "directory" then
    fail("a saída de " .. name .. " deve ser um diretório")
  end
  remove_tree(output)
  remove_tree(pdf)
  print("Arquivos gerados removidos para " .. name .. ".")
end

local function clean_development()
  if not kind(build) then
    print("Nenhum arquivo de desenvolvimento para remover.")
    return
  end
  if kind(build) ~= "directory" then
    fail("development/build/ deve ser um diretório")
  end
  remove_tree(build)
  print("Arquivos gerados removidos de development/build/.")
end

local function new_document(template, name, build_now)
  local items = templates()
  local selected
  if template and template ~= "" then
    for _, item in ipairs(items) do
      if item[1] == template then selected = item[1]; break end
    end
    if not selected then fail("modelo desconhecido: " .. template) end
  else
    print_templates(items)
    local answer = read_answer("\nSelecione um modelo [1]: ", "1")
    local index = tonumber(answer == "" and "1" or answer)
    if not index or index % 1 ~= 0 or not items[index] then
      fail("selecione um número da lista")
    end
    selected = items[index][1]
  end
  if not name or name == "" then
    name = read_answer("Identificador do documento: ", "")
  end
  valid_name(name)
  local source = join(development, "templates", selected)
  local target = join(documents, name)
  if kind(join(source, "main.tex")) ~= "file" then
    fail("o modelo " .. selected .. " não contém main.tex")
  end
  if kind(target) then fail("o documento " .. name .. " já existe") end
  if kind(makefile) ~= "file" then
    fail("Makefile de documento não encontrado")
  end
  mkdir(documents)
  copy_tree(source, target)
  copy_file(makefile, join(target, "Makefile"))
  mkdir(join(target, "img"))
  print("\nDocumento criado em:\n  documents/" .. name .. "/main.tex\n")
  print("Edite somente esse arquivo para começar.")
  local answer = build_now
  if not answer or answer == "" then
    answer = read_answer("Compilar agora? [S/n]: ", "s")
  end
  answer = (answer == "" and "s" or answer):lower()
  if answer == "s" or answer == "sim" or
      answer == "y" or answer == "yes" then
    build_document(name)
  elseif answer == "n" or answer == "não" or
      answer == "nao" or answer == "no" then
    print("Use `make build` quando desejar compilar.")
  else
    fail("responda sim ou não")
  end
end

local function check_style()
  local extensions = {
    cls = true, bib = true, lua = true, md = true, sh = true,
    sty = true, tsv = true, tex = true,
  }
  local files = {}
  local function scan(path, relative)
    for _, name in ipairs(names(path)) do
      local child = relative == "" and name or relative .. "/" .. name
      local child_path = join(path, name)
      if kind(child_path) == "directory" then
        if child ~= ".git" and child ~= ".agents" and
            child ~= ".aws" and child ~= ".codex" and
            child ~= "documents" and child ~= "development/build" and
            child ~= "development/reference-material" then
          scan(child_path, child)
        end
      elseif kind(child_path) == "file" then
        local ext = name:match("%.([^.]+)$")
        if extensions[ext] or name == "Makefile" or
            name == ".gitignore" or name:match("%.bib%.example$") then
          files[#files + 1] = child_path
        end
      end
    end
  end
  scan(root, "")
  local previous = arg
  arg = files
  dofile(join(scripts_dir, "check-line-length.lua"))
  arg = previous
end

local smoke = {"brand", "cmyk", "document", "compact", "slides"}
local canonical_templates = {
  "documento", "atas", "relatorios", "plano-projeto",
  "plano-trabalho", "estatuto", "slides", "cartao",
}

local function dev_test()
  check_style()
  for _, name in ipairs(smoke) do
    latexmk("tests/smoke/" .. name .. ".tex",
      join(build, "tests"), development)
  end
end

local function dev_reference()
  latexmk("tests/reference/brand-reference.tex",
    join(build, "reference"), development)
end

local function dev_templates()
  for _, name in ipairs(canonical_templates) do
    latexmk("templates/" .. name .. "/main.tex",
      join(build, "templates", name), development)
  end
end

local action = arg[1]
if action == "new" then
  new_document(arg[2], arg[3], arg[4])
elseif action == "list" then
  print_templates(templates())
  print("")
  print_documents(document_names())
elseif action == "build-all" then
  local items = document_names()
  if #items == 0 then print("Nenhum documento criado. Execute 'make new'.") end
  for _, name in ipairs(items) do build_document(name) end
elseif action == "build" then
  build_document(choose_document(arg[2]))
elseif action == "build-path" then
  build_document(document_path(arg[2]))
elseif action == "validate-path" then
  document_path(arg[2])
elseif action == "clean-path" then
  clean_document(document_path(arg[2]))
elseif action == "clean" then
  for _, name in ipairs(document_names()) do clean_document(name) end
  clean_development()
elseif action == "clean-development" then
  clean_development()
elseif action == "check-style" then
  check_style()
elseif action == "dev-test" then
  dev_test()
elseif action == "dev-reference" then
  dev_reference()
elseif action == "dev-templates" then
  dev_templates()
elseif action == "dev-all" then
  dev_test()
  dev_reference()
  dev_templates()
else
  fail("ação desconhecida")
end
