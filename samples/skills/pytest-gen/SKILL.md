---
name: pytest-gen
description: Génère des tests pytest complets - à utiliser pour générer des tests, créer des suites de tests, ou tester du code Python
---

# Skill Génération pytest

Lors de la génération de tests, suivez cette structure.

## Organisation des tests

- Regroupez les tests par fonction testée
- Utilisez `@pytest.mark.parametrize` pour plusieurs entrées
- Utilisez des fixtures pour la configuration partagée
- Suivez le modèle arrange/act/assert

## Exigences de couverture

- Cas nominal (utilisation attendue)
- Cas limites (chaînes vides, None, valeurs aux bornes)
- Cas d'erreur (entrée invalide, fichier introuvable, mauvais types)
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
