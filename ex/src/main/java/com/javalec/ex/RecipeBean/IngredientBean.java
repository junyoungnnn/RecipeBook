package com.javalec.ex.RecipeBean;

import java.io.Serializable;

public class IngredientBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String ingredientName;
    private String quantity;

    // Getters and setters
    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }
}