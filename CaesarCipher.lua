local CaesarCipher = {}


---------------------------------- ENCRYPTION ----------------------------------
-- encrypts a single character
function CaesarCipher.EncryptSingleChar (plainChar, key)
	-- a = 97, z = 122, A = 65, Z = 90
	local char1 = plainChar
	local char2 = char1

	-- case1: lowercase
	if (char1:byte() >= 97) and (char1:byte() <= 122) then

		if char1:byte() + key > 122 then
			char2 = string.char(char1:byte() + key - 26)
		else
			char2 = string.char(char1:byte() + key)
		end

	-- case2: uppercase
	elseif (char1:byte() >= 65) and (char1:byte() <= 90) then

		if char1:byte() + key > 90 then
			char2 = string.char(char1:byte() + key - 26)
		else
			char2 = string.char(char1:byte() + key)
		end

	else -- does nothing
		--print("char1 is NOT an alphabetic character!")
	end

	return char2
end

-------------------

-- encrypts a string
function CaesarCipher.EncryptStr (plainStr, key)
	local str1 = plainStr
	local str2 = ""

	for i in str1:gmatch(".") do
		str2 = str2 .. CaesarCipher.EncryptSingleChar(i, key)
	end

	return str2
end

-------------------

-- encrypts a file
function CaesarCipher.EncryptFile (plainFileName, key)
	local cipherFileName = plainFileName:sub(1, #plainFileName - 4) .. "Cipher.txt"
	print(cipherFileName)

	local plainFile = assert(io.open(plainFileName, "r"))
	local cipherFile = assert(io.open(cipherFileName, "w"))

	for l in plainFile:lines() do
		local cipherStr = ""

		for i in l:gmatch(".") do
			cipherStr = cipherStr .. CaesarCipher.EncryptSingleChar(i, key)
		end

		cipherFile:write(cipherStr)
		cipherFile:write("\n")
	end

	plainFile:close()
	cipherFile:close()
end


---------------------------------- DECRYPTION ----------------------------------
-- decrypts a single character
-- key is previously known
function CaesarCipher.DecryptSingleCharWithKey (cipherChar, key)
	-- a = 97, z = 122, A = 65, Z = 90
	local char1 = cipherChar
	local char2 = char1

	-- case1: lowercase
	if (char1:byte() >= 97) and (char1:byte() <= 122) then

		if char1:byte() - key < 97 then
			char2 = string.char(char1:byte() - key + 26)
		else
			char2 = string.char(char1:byte() - key)
		end

	-- case2: uppercase
	elseif (char1:byte() >= 65) and (char1:byte() <= 90) then

		if char1:byte() - key < 65 then
			char2 = string.char(char1:byte() - key + 26)
		else
			char2 = string.char(char1:byte() - key)
		end

	else -- does nothing
		--print("char1 is NOT an alphabetic character!")
	end

	return char2
end

-------------------

-- decrypts a string
-- key is previously known
function CaesarCipher.DecryptStrWithKey (cipherStr, key)
	local str1 = cipherStr
	local str2 = ""

	for i in str1:gmatch(".") do
		str2 = str2 .. CaesarCipher.DecryptSingleCharWithKey(i, key)
	end

	return str2
end

-------------------

-- attempts to brute-force decrypt a string
-- prints all 25 possible answers
function CaesarCipher.DecryptStrWithoutKey (cipherStr)
	local str1 = cipherStr
	local str2 = ""

	for key = 1, 25 do
		for i in str1:gmatch(".") do
			str2 = str2 .. CaesarCipher.DecryptSingleCharWithKey(i, key)
		end

		print(key)
		print(str2)
		str2 = ""
	end
end

-------------------

-- decrypts a file
-- key is previously known
function CaesarCipher.DecryptFileWithKey (cipherFileName, key)
	local plainFileName = cipherFileName:sub(1, #cipherFileName - 4) .. "Plain.txt"
	print(plainFileName)

	local cipherFile = assert(io.open(cipherFileName, "r"))
	local plainFile = assert(io.open(plainFileName, "w"))

	for l in cipherFile:lines() do
		local plainStr = ""

		for i in l:gmatch(".") do
			plainStr = plainStr .. CaesarCipher.DecryptSingleCharWithKey(i, key)
		end

		plainFile:write(plainStr)
		plainFile:write("\n")
	end

	cipherFile:close()
	plainFile:close()
end

-------------------

-- attempts to brute-force decrypt a file
-- creates a file with all 25 possible answers
function CaesarCipher.DecryptFileWithoutKey (cipherFileName)
	local plainFileName = cipherFileName:sub(1, #cipherFileName - 4) .. "PlainRude.txt"
	print(plainFileName)

	local cipherFile = assert(io.open(cipherFileName, "r"))
	local plainFile = assert(io.open(plainFileName, "w"))

	for key = 1, 25 do
		local cipherFile = assert(io.open(cipherFileName, "r"))

		plainFile:write(key)
		plainFile:write("\n\n")

		for l in cipherFile:lines() do
			local plainStr = ""

			for i in l:gmatch(".") do
				plainStr = plainStr .. CaesarCipher.DecryptSingleCharWithKey(i, key)
			end

			plainFile:write(plainStr)
			plainFile:write("\n")
		end

		plainFile:write("\n-------------------\n\n")
	end

	cipherFile:close()
	plainFile:close()
end

-------------------

return CaesarCipher
