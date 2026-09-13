---
name: pytest-gen
description: Génère des tests pytest complets - à utiliser lors de la génération de tests, de la création de suites de tests, ou du test de code Python
---

# Compétence de génération Pytest

Lors de la génération de tests, suis cette structure.

## Organisation des tests

- Regroupe les tests par fonction testée
- Utilise `@pytest.mark.parametrize` pour les entrées multiples
- Utilise des fixtures pour la configuration partagée
- Suis le modèle arrange/act/assert (préparer/agir/vérifier)

## Exigences de couverture

- Cas nominal (utilisation attendue)
- Cas limites (chaînes vides, None, valeurs limites)
- Cas d'erreur (entrée invalide, fichier introuvable, types incorrects)
- Intégration (fonctions fonctionnant ensemble)

## Modèle

```python
import pytest
from module_under_test import function_to_test


@pytest.fixture
def sample_data():
    """Fournit des données de test partagées."""
    return {"key": "value"}


class TestFunctionName:
    """Tests pour function_name."""

    def test_happy_path(self, sample_data):
        result = function_to_test(valid_input)
        assert result == expected_output

    def test_empty_input(self):
        result = function_to_test("")
        assert result == expected_for_empty

    @pytest.mark.parametrize("input_val,expected", [
        ("valid", True),
        ("", False),
        (None, False),
    ])
    def test_various_inputs(self, input_val, expected):
        assert function_to_test(input_val) == expected
```
