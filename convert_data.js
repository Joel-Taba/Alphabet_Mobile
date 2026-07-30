const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function convertToDart(inputFile, outputFile, arraysToExtract) {
  const tempJsFile = inputFile.replace('.ts', '.temp.cjs');
  
  // Transpile TS to CommonJS using esbuild
  execSync(`npx esbuild ${inputFile} --format=cjs --outfile=${tempJsFile}`);
  
  // Require the generated JS using absolute path
  const exportsObj = require(path.resolve(tempJsFile));

  let dartCode = `import 'dart:convert';\n\n`;
  
  for (const arrName of arraysToExtract) {
    const data = exportsObj[arrName];
    if (data) {
      // Stringify nicely so it's readable
      const jsonStr = JSON.stringify(data, null, 2);
      dartCode += `final List<dynamic> ${arrName} = jsonDecode(r'''\n${jsonStr}\n''');\n\n`;
    } else {
      console.warn(`Warning: Array ${arrName} not found in ${inputFile}`);
    }
  }

  fs.writeFileSync(outputFile, dartCode);
  console.log(`Converted ${inputFile} -> ${outputFile}`);
  
  // Cleanup
  fs.unlinkSync(tempJsFile);
}

convertToDart(
  'src/data/sign-exercise-catalog.ts', 
  '../app/lib/data/sign_exercise_catalog.dart',
  ['TRAITS', 'COURBES', 'POINTS', 'CROCHETS']
);

convertToDart(
  'src/data/flores-gong-nota.ts', 
  '../app/lib/data/flores_gong_nota.dart',
  ['MINUSCULES', 'MAJUSCULES', 'CHIFFRES']
);

convertToDart(
  'src/data/letter-formation-catalog.ts', 
  '../app/lib/data/letter_formation_catalog.dart',
  ['VOWELS', 'CONSONANTS', 'UPPERCASE', 'DIGITS', 'LETTER_CATALOG']
);
