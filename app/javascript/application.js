import Rails from "@rails/ujs";  // Ensures Rails UJS (for Rails-specific helpers) is loaded
Rails.start();

import "@hotwired/turbo-rails"; // Turbo to handle page loading optimizations
import "controllers"; // Assuming Stimulus controllers are also being used

// === Variant Handling for Products ===

document.addEventListener('DOMContentLoaded', () => {
  const addVariantButton = document.getElementById('add-variant');
  const variantsContainer = document.getElementById('variants-container')?.querySelector('tbody');
  const variantTemplate = document.getElementById('variant-template')?.innerHTML;

  if (addVariantButton && variantsContainer && variantTemplate) {
    const addVariantField = () => {
      const index = variantsContainer.querySelectorAll('.variant-fields').length;
      const newVariantFields = variantTemplate.replace(/__index__/g, index); // Dynamically replaces index for new variants
      variantsContainer.insertAdjacentHTML('beforeend', newVariantFields); // Inserts the new variant fields
      updateEventListeners(); // Updates event listeners for new dynamic elements
      updateProductPreview(); // Updates the preview of the product
    };

    const updateProductPreview = () => {
      const name = document.querySelector('input[name="product[name]"]')?.value;
      const description = document.querySelector('textarea[name="product[description]"]')?.value;
      const price = document.querySelector('input[name="product[price]"]')?.value;
      const image = document.querySelector('input[name="product[image]"]')?.files?.[0];
      
      const previewImage = document.querySelector('.card-img-top');
      const previewTitle = document.querySelector('.card-title');
      const previewText = document.querySelector('.card-text');

      if (image) {
        const reader = new FileReader();
        reader.onload = function(e) {
          previewImage.src = e.target.result;
        };
        reader.readAsDataURL(image);
      } else if (previewImage) {
        previewImage.src = ''; // Clear the image if none is selected
      }

      if (previewTitle) {
        previewTitle.textContent = name || 'Product Name';
      }
      
      if (previewText) {
        previewText.innerHTML = `<p>${description || 'Product description goes here.'}</p><p><strong>Price: $</strong> ${price || '0.00'}</p>`;
      }

      const variantsPreviewContainer = document.querySelector('.variants');
      if (variantsPreviewContainer) {
        variantsPreviewContainer.innerHTML = ''; // Clear existing previews

        // Loop through each variant field and update preview
        document.querySelectorAll('.variant-fields').forEach(row => {
          const color = row.querySelector('input[name*="[color]"]')?.value;
          const size = row.querySelector('input[name*="[size]"]')?.value;
          const quantity = row.querySelector('input[name*="[quantity]"]')?.value;

          variantsPreviewContainer.innerHTML += `
            <div class="variant">
              <p><strong>Color:</strong> ${color || 'N/A'}</p>
              <p><strong>Size:</strong> ${size || 'N/A'}</p>
              <p><strong>Quantity:</strong> ${quantity || 'N/A'}</p>
            </div>
          `;
        });
      }
    };

    const updateEventListeners = () => {
      // Remove variant functionality
      variantsContainer.querySelectorAll('.remove-variant').forEach(button => {
        button.addEventListener('click', () => {
          button.closest('.variant-fields')?.remove();
          updateProductPreview(); // Update the preview after a variant is removed
        });
      });

      // Update product preview as user inputs name, description, price, or image
      document.querySelectorAll('input[name="product[name]"], textarea[name="product[description]"], input[name="product[price]"], input[name="product[image]"]').forEach(input => {
        input.addEventListener('input', updateProductPreview);
      });
    };

    // Initial setup for the variant fields
    addVariantButton.addEventListener('click', addVariantField); // Handle adding variants
    updateEventListeners(); // Attach listeners to current elements
    updateProductPreview(); // Generate initial preview if data exists
  }
});

// === Heart Icon Wishlist Toggle (for Wishlist) ===

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.wishlist-button').forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault(); // Prevent page reload

      const productId = this.querySelector('span').id.split('-')[1]; // Get product ID from span's ID
      const heartIcon = document.getElementById(`wishlist-${productId}`); // Get the specific heart icon

      // Toggle between empty and filled heart by triggering a full page redirect to Rails routes
      if (heartIcon.src.includes('heart-empty.png')) {
        // Redirect to the create action to add the product to the wishlist
        window.location.href = `/clients/wishlists?product_id=${productId}&method=post`;
      } else {
        // Redirect to the destroy action to remove the product from the wishlist
        window.location.href = `/clients/wishlists/${productId}?method=delete`;
      }
    });
  });
});

// === Filter Form Handling (No AJAX, form submits via normal request) ===

document.addEventListener("DOMContentLoaded", function() {
  const filterForm = document.getElementById('filter-form'); // Filter form selector

  if (filterForm) {
    // No need to preventDefault, let the form submit normally when the button is clicked
    // The form will be submitted via a full-page request when the button is clicked
    // Simply ensure any JavaScript-related UI tasks are handled before the form submits
  }
});
