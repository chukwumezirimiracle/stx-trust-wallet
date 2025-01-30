;; Title: DePo (Decentralized Price Oracle) Aggregator
;; depo-aggregator.clar

;; title: depo-aggregator
;; version:
;; summary:
;; description:
;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_STALE_PRICE (err u101))
(define-constant ERR_INSUFFICIENT_PROVIDERS (err u102))
(define-constant ERR_PRICE_TOO_LOW (err u103))
(define-constant ERR_PRICE_TOO_HIGH (err u104))
(define-constant ERR_PRICE_DEVIATION (err u105))

;; traits
;;
(define-constant PRICE_PRECISION u100000000)  ;; 8 decimal places
(define-constant MAX_PRICE_AGE u900)          ;; 15 minutes in blocks
(define-constant MIN_PRICE_PROVIDERS u3)      ;; Minimum required price providers
(define-constant MAX_PRICE_PROVIDERS u10)     ;; Maximum allowed price providers
(define-constant MAX_PRICE_DEVIATION u200)    ;; 20% maximum deviation from median
(define-constant MIN_VALID_PRICE u100000)     ;; Minimum valid price
(define-constant MAX_VALID_PRICE u1000000000) ;; Maximum valid price

;; token definitions
;;
;; Data Variables
(define-data-var current-price uint u0)
(define-data-var last-update-block uint u0)
(define-data-var active-providers uint u0)

;; Error Handling
(define-map error-messages (response uint uint) (string-ascii 64))
(map-insert error-messages ERR_NOT_AUTHORIZED "Not authorized to perform this action")
(map-insert error-messages ERR_STALE_PRICE "Price data is stale")
(map-insert error-messages ERR_INSUFFICIENT_PROVIDERS "Insufficient number of price providers")
(map-insert error-messages ERR_PRICE_TOO_LOW "Price is below minimum threshold")
(map-insert error-messages ERR_PRICE_TOO_HIGH "Price is above maximum threshold")
(map-insert error-messages ERR_PRICE_DEVIATION "Price deviates too much from median")



;;
;; Maps
(define-map price-providers principal bool)
(define-map provider-prices principal uint)
(define-map provider-last-update principal uint)
(define-map active-provider-list uint principal)
(define-map historical-prices uint {price: uint, block: uint})
;; Add new error messages
(map-insert error-messages ERR_ZERO_PRICE "Price cannot be zero")
(map-insert error-messages ERR_INVALID_BLOCK "Invalid block height provided")
(map-insert error-messages ERR_PROVIDER_EXISTS "Provider already exists")

;; data vars
;;
;; Private Functions
(define-private (is-contract-owner)
    (is-eq tx-sender CONTRACT_OWNER))

;; data maps
;;
(define-private (is-authorized-provider (provider principal))
    (default-to false (map-get? price-providers provider)))

;; public functions
;;
(define-private (get-provider-price (provider principal))
    (default-to u0 (map-get? provider-prices provider)))

;; read only functions
;;
(define-private (collect-provider-prices (index uint) (prices (list 100 uint)))
    (match (map-get? active-provider-list index)
        provider (let ((price (get-provider-price provider)))
                    (if (> price u0)
                        (unwrap! (as-max-len? (append prices price) u100) prices)
                        prices))
        prices))